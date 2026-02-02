<?php

namespace Database\Seeders;

use App\Models\Item;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ItemSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * Insert 10,000 dummy records to demonstrate caching benefits
     */
    public function run(): void
    {
        // Insert 10,000 items in chunks for better performance
        $chunk_size = 500;

        for ($i = 0; $i < 10000; $i += $chunk_size) {
            $items = [];
            for ($j = 0; $j < $chunk_size && ($i + $j) < 10000; $j++) {
                $items[] = [
                    'name' => 'Item ' . ($i + $j + 1),
                    'created_at' => now(),
                    'updated_at' => now(),
                ];
            }
            Item::insert($items);
        }
    }
}
