<?php

    namespace Clincker;

    use Clincker\Lib\Dotenv;

    define('CLINCKER_ROOT', __DIR__);

    require_once CLINCKER_ROOT.'/Lib/Dotenv.php';

    class Clincker {
        public function start(): void {
            echo Dotenv::get('HTTPS_PORT');
        }
    }
