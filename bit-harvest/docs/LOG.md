
# 002 - Criar o personagem e sua máquina de estado
- ...

# 001 - Criar a estrutura base dos tilesets
- Criado o recurso `tilesets/game_tile_set.tres` que centraliza todos os tilesets do jogo num único `TileSet` do Godot — isso evita ter que gerenciar múltiplos recursos separados e permite que as camadas compartilhem o mesmo conjunto de tiles
- Configurado um **Terrain Set** (modo "Corners & Sides") com dois terrains: `Grass Terrain` e `Tilled Dirt Terrain`. Os terrains permitem que o Godot preencha bordas e cantos automaticamente via bitmask, sem precisar pintar cada tile de transição na mão
- A água foi configurada com **animação de 4 frames** a 0.2s cada — o ciclo de animação fica no próprio TileSet, então qualquer TileMapLayer que use o tile de água já anima automaticamente
- Adicionado o atlas de decorações (`basic_grass_biome_things.png`) como quarta fonte no TileSet para árvores, arbustos e outros elementos de natureza
- Criada a cena de teste `scenes/test/test_scene_tilemap.tscn` com um nó `GameTileMap` contendo 4 camadas (`TileMapLayer`) em ordem de profundidade: **Water → Grass → TilledDirt → Nature** — a separação em camadas permite controle independente de z-index e colisão por tipo de terreno
- Assets organizados em `assets/game/` (separando os sprites "de jogo" dos arquivos de referência que ficam em `docs/base-assets/`)