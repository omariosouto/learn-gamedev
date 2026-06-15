
# 003 - Criar o estado para as ações do personagem `tilling`, `watering`, `chopping`...

# 002 - Criar o personagem e sua máquina de estado para `walk` e `idle`
- Criada a cena `scenes/characters/player.tscn` com `AnimatedSprite2D`, `CollisionShape2D` (círculo) e o nó `StateMachine` como filho — a hierarquia reflete que a máquina de estado pertence ao personagem, não ao mundo
- Mapeados os inputs `walk_up`, `walk_down`, `walk_left`, `walk_right` no `project.godot`
- O `SpriteFrames` foi configurado com **20 animações** extraídas de dois spritesheets (`basic_character_actions.png` e `basic_character_spritesheet.png`): walk, idle, chopping, tilling e watering — cada uma nas 4 direções. Já subir todos os sprites agora evita ter que reabrir o atlas toda vez que um novo estado for adicionado
- Criado `scripts/state_machine/node_state.gd` como classe base `NodeState` com os hooks `_on_process`, `_on_physics_process`, `_on_next_transitions`, `_on_enter` e `_on_exit` — cada estado só sobrescreve o que precisa
- Criado `scripts/state_machine/node_state_machine.gd` (`NodeStateMachine`) que descobre os estados automaticamente pelos filhos, conecta o signal `transition` de cada um e chama os hooks de ciclo de vida na ordem certa. A transição é iniciada pelo próprio estado via `transition.emit("NomeDoEstado")`, mantendo a lógica de "quando sair" dentro do estado que sabe disso
- Criado `player.gd` com `class_name Player` — ao definir um `class_name` no script, o Godot converte o nó numa classe tipada, permitindo guardar propriedades compartilhadas entre estados (ex: `player_direction`) sem precisar de um autoload global. Cada estado recebe o `Player` como `@export` e acessa/modifica esse estado diretamente
- `walk_state.gd`: toca a animação correta pela direção cardinal, salva a direção em `player.player_direction` (só quando diferente de zero, para o idle saber para qual lado o jogador estava olhando), aplica `velocity` e chama `move_and_slide()`. Emite `"Idle"` quando não há input
- `idle_state.gd`: lê `player.player_direction` para tocar a animação idle na direção correta — assim o personagem "para olhando para onde foi". Emite `"Walk"` quando detecta input
- Criado `scripts/game_input_events.gd` com `class_name GameInputEvents` e membros `static` — funciona como singleton sem precisar registrar um autoload nas configurações do projeto. `movement_input()` retorna apenas direções cardinais puras (UP/DOWN/LEFT/RIGHT/ZERO), simplificando os `if`s nos estados

# 001 - Criar a estrutura base dos tilesets
- Criado o recurso `tilesets/game_tile_set.tres` que centraliza todos os tilesets do jogo num único `TileSet` do Godot — isso evita ter que gerenciar múltiplos recursos separados e permite que as camadas compartilhem o mesmo conjunto de tiles
- Configurado um **Terrain Set** (modo "Corners & Sides") com dois terrains: `Grass Terrain` e `Tilled Dirt Terrain`. Os terrains permitem que o Godot preencha bordas e cantos automaticamente via bitmask, sem precisar pintar cada tile de transição na mão
- A água foi configurada com **animação de 4 frames** a 0.2s cada — o ciclo de animação fica no próprio TileSet, então qualquer TileMapLayer que use o tile de água já anima automaticamente
- Adicionado o atlas de decorações (`basic_grass_biome_things.png`) como quarta fonte no TileSet para árvores, arbustos e outros elementos de natureza
- Criada a cena de teste `scenes/test/test_scene_tilemap.tscn` com um nó `GameTileMap` contendo 4 camadas (`TileMapLayer`) em ordem de profundidade: **Water → Grass → TilledDirt → Nature** — a separação em camadas permite controle independente de z-index e colisão por tipo de terreno
- Assets organizados em `assets/game/` (separando os sprites "de jogo" dos arquivos de referência que ficam em `docs/base-assets/`)