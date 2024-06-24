<?php

    namespace Clincker;

    use Clincker\Lib\Database;
    use Exception;

    define('CLINCKER_ROOT', __DIR__);

    require_once CLINCKER_ROOT.'/Lib/Dotenv.php';
    require_once CLINCKER_ROOT.'/Lib/Database.php';

    class Clincker {
        public function start(): void {
            try {
            var_dump(Database::getConnection());
            } catch (Exception $exception) {
                print_r($exception->getMessage());
            }
        }
    }
