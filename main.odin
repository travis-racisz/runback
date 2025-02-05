package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"
world := create_world()











main :: proc() {

	first_cat := create_entity(&world, 1)
	second_cat := create_entity(&world, 2)
	world.global_points = 100
	rl.InitWindow(rl.GetScreenHeight(), rl.GetScreenHeight(), "Run Back Experiment")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()
	add_position(&world, first_cat, {x = 100, y = 100, is_returning = false})
	add_velocity(&world, first_cat, {2,0})
	add_points_contributer(&world, first_cat, {amount = 1, is_active = true})
	add_sprite(
		&world,
		first_cat,
		{
			idle_texture = rl.LoadTexture(
				"./assets/AllCatsDemo/AllCatsDemo/BatmanCatFree/IdleCatt.png",
			),
			move_right_texture = rl.LoadTexture(
				"./assets/AllCatsDemo/AllCatsDemo/BatmanCatFree/JumpCattt.png",
			),
		},
	)
	add_animation_state(&world, first_cat, {state = .IDLE, current_frame = 0, animation_speed = 8})
	add_unlocked(&world, first_cat)

	// second cat 
	add_position(&world, second_cat, {x = 100, y = 200, is_returning = false})
	add_sprite(
		&world,
		second_cat,
		{
			idle_texture = rl.LoadTexture(
				"./assets/AllCatsDemo/AllCatsDemo/BlackCat/IdleCatb.png",
			),
			move_right_texture = rl.LoadTexture(
				"./assets/AllCatsDemo/AllCatsDemo/BlackCat/JumpCabt.png",
			),
		},
	)
	// add_unlocked(&world, second_cat)
	add_points_contributer(&world, second_cat, {amount = 5, is_active = true})
	add_animation_state(
		&world,
		second_cat,
		{state = .IDLE, animation_speed = 8, current_frame = 0},
	)
	add_buttons(&world, first_cat, world.storage.positions[first_cat].y)
	add_buttons(&world, second_cat, world.storage.positions[second_cat].y)
	rl.GuiLoadStyle("./assets/candy.rgs")


	for !rl.WindowShouldClose() {
	

		rl.BeginDrawing()

		boundary := rl.Rectangle{
			x = 100,
			y = 50, 
			width = 1100,
			height = 600,
			
		}
		rl.DrawRectangleLinesEx(boundary, 3.0, rl.BLACK)

		
		render_system(&world)
		render_buttons_system(&world)


		for entity in world.storage.entities {
			unlocked, ok := world.storage.unlocked[entity]
			if ok {
				movement_system(&world, entity)
			}
		}
		score_text := strings.clone_to_cstring(fmt.tprintf("points: %d", world.global_points))
		rl.DrawText(score_text, 10, 10, 20, rl.WHITE)

		rl.ClearBackground(rl.GRAY)
		rl.EndDrawing()
		defer free_all(context.temp_allocator)

	}


}



