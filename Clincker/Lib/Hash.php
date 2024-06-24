<?php

    namespace Clincker\Lib;

    class Hash {
        public static function get(): string {
            return $_GET['hash'] ?? '';
        }
    }
