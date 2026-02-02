<?php

use App\Http\Controllers\SpeedTestController;
use Illuminate\Support\Facades\Route;

// Health check for deployment
Route::get('/health', function () {
    return response()->json([
        'status' => 'ok',
        'timestamp' => now(),
    ]);
});

// Demo page
Route::get('/', function () {
    return view('demo');
});

// Speed test endpoints (JSON API)
Route::get('/test', [SpeedTestController::class, 'test']);
Route::get('/invalidate', [SpeedTestController::class, 'invalidate']);
