<?php

    namespace Clincker\Lib;

    class Dotenv {
        private static array $content;

        private static function getContent(): array {
            if (empty(self::$content)) {
                self::$content = parse_ini_file(CLINCKER_ROOT.'/../.env');
            }

            return self::$content;
        }

        public static function get(string $key): ?string {
            return self::getContent()[$key] ?? null;
        }
    }
