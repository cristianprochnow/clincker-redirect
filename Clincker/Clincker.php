<?php

    namespace Clincker;

    use Clincker\Lib\Database;
    use Clincker\Lib\Hash;
    use PDO;

    define('CLINCKER_ROOT', __DIR__);

    require_once CLINCKER_ROOT.'/Lib/Dotenv.php';
    require_once CLINCKER_ROOT.'/Lib/Database.php';
    require_once CLINCKER_ROOT.'/Lib/Hash.php';

    class Clincker {
        public function start(): void {
            $this->redirect();
        }

        private function redirect(): void {
            $content = $this->search();
            $url = $content['original_url'] ?? '';

            if (empty($url)) {
                $this->notFound();
            }

            $this->href($url);
        }

        private function href(string $url): void {
            header("Location: {$url}");
            die();
        }

        private function notFound(): void {
            exit(file_get_contents(CLINCKER_ROOT.'/Views/404.html'));
        }

        private function search(): array {
            $statement = Database::getConnection()
                ->prepare(
                    "SELECT original_url
                    FROM links
                    WHERE hash = :hash"
                );
            $statement->bindValue(':hash', Hash::get());
            $statement->execute();

            $content = [];
            while ($row = $statement->fetch(PDO::FETCH_ASSOC)) {
                $content = $row;

                break;
            }

            return $content;
        }
    }
