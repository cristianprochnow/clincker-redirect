<?php

    ini_set('error_reporting', E_ALL);

    require_once __DIR__.'/Clincker/Clincker.php';

    use Clincker\Clincker;

    (new Clincker())->start();
