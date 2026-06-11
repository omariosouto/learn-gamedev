## 2026-06-10 - Trabalhando com Parallax

- Estrutura do parallax na Godot: `ParallaxBackground > ParallaxLayer > Sprite2D`
    - `ParallaxBackground` é o nó pai que gerencia todas as layers
    - Cada `ParallaxLayer` tem uma velocidade de movimento diferente
    - O `Sprite2D` dentro é a imagem que vai se mover
- `motion_scale` na `ParallaxLayer` controla a velocidade relativa à câmera
    - `Vector2(0.1, 0.1)` = move a 10% da velocidade da câmera — quanto menor, mais "longe" parece
- `motion_mirroring` faz o sprite repetir horizontalmente em loop
    - O valor deve ser a largura da imagem em pixels para o loop ser imperceptível
    - Ex: `Vector2(288, 0)` para imagens de 288px de largura
- Viewport ajustado para 400x208 para dar mais espaço horizontal visível
- TileSets extraídos para arquivos `.tres` externos (`tiles/terrain.tres`, `tiles/decoration.tres`), limpando a cena
- Criou cena separada `forest.tscn` para experimentar o parallax com os assets da Autumn Forest
    - Cada cena pode ter seus próprios limites de câmera — removeu o `limit_right` fixo do player
- `limit_top = 8` na câmera do player para evitar corte no topo do background
    > **Ajuste temporário**: o ideal seria configurar os limites de câmera em cada cena, não no player. Corrigir no futuro


### 🏆 CHALLENGE
- Criar uma cena nova usando os assets de Tropics (`3 - Tropics/`)
- Mapear os tilesets de Tropics como novos tile sources no TileSet de terrain e decoration
- Estender as decorações para incluir o mar animado
    - Usar o recurso de **animação de TileSet** da Godot (não código!) para animar os frames do tile de água
    - O sprite de água já tem frames — `Water_frames (16 x 32).png`


## 2026-06-10 - Criando o mapa da fase usando tiles

### Começando a mexer
- Sempre desenhamos o mapa com TileMapLayer
    - TileMap
        - Desenha o mapa
    - TileSet
        - Select -> Physics
            - Seleciona toda a área de colisão desse pedaço de mapa

### Mapa da Fase com Colisão nas Plataformas
- Separar os tiles em:
    - Tiles sólidos (colisão completa — chão, paredes)
    - Plataformas one-way: colisão só de cima pra baixo, o jogador pula de baixo e atravessa
        - No TileSet > Physics > marcar `One Way` no polígono de colisão
        - O polígono deve cobrir só a borda superior do tile, não a caixa inteira
- `limit_right` da câmera foi para `999999999` para suportar a fase maior sem cortar

### Organizando os níveis de tiles da fase
- Criar uma hierarquia na cena: `Tiles [Node2D] > Terrain [TileMapLayer] + Decoration [TileMapLayer]`
    - `Terrain`: tudo que tem colisão (chão, plataformas) — salvo em `tiles/terrain.tres`
    - `Decoration`: árvores, flores, casas — sem colisão, só visual — salvo em `tiles/decoration.tres`
- Tiles grandes (árvores, casas) precisam de `size_in_atlas` no TileSet para agrupar os pedaços em um único tile
    - Exemplo: árvore 3x3 tiles → `size_in_atlas = Vector2i(3, 3)`
- Sprites grandes fora do alinhamento da grade precisam de ajuste em `TileSet > Rendering > Texture Origin`
    - Isso corrige o offset visual sem mover o tile no mapa (ex: casa de 7x6 tiles)
- Salvar os TileSets como arquivos `.tres` em `tiles/` para reutilizar entre cenas
- `z_index = 1` no `AnimatedSprite2D` do player para ele renderizar na frente das decorações

### Patterns e reutilização
- Dentro do TileMap, `Patterns` permitem salvar grupos de tiles para pintar seções repetidas facilmente
- Dentro do TileSet dá pra renomear os sources e salvar como `.tres` para importar em outras fases

## 2026-06-10 - Configurando teclas de controle do jogador

- As ações de input ficam em `Project > Project Settings > Input Map`
- Criou 3 ações customizadas no `project.godot`: `left`, `right` e `jump`
    - `left`: A + seta esquerda
    - `right`: D + seta direita
    - `jump`: Espaço + W + seta cima
- Substituiu as ações padrão da Godot (`ui_left`, `ui_right`, `ui_accept`) pelas ações customizadas no `player.gd`
    - Boa prática: ações `ui_*` são para menus/UI, não para gameplay


## 2026-06-09 - Câmera seguindo o jogador

- Adicionou `Camera2D` como filho do `Player` — por ser filho, ela segue automaticamente sem código
- Configurou limites da câmera (`limit_left/top/right/bottom`) para não sair dos bounds do nível
- Ativou `position_smoothing_enabled = true` para a câmera suavizar o movimento
- Ocultou o `CollisionShape2D` do player (`visible = false`) para não aparecer em cena
- Aumentou o viewport de 150x100 para 300x200 px para ter mais área visível
- Ajustou SPEED de 30 para 80 para compensar o viewport maior
- Expandiu o cenário com mais 3 plataformas (`CollisionShape2D2/3/4`) para ter mais chão para andar


## 2026-06-09 - Animando sprites com código

- Segura o Option para fazer referências a objetos na UI do Godot para gerar a linha automaticamente
    - `@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D`
- Adicionou animações `walk` (6 frames do Waddling) e `jump` (1 frame) no `SpriteFrames` do player
- Lógica de troca de animação no `_physics_process`:
    - No chão + movendo: `sprite.play("walk")` + `flip_h` para inverter direção
    - No chão + parado: `sprite.play("idle")`
    - No ar: `sprite.play("jump")`
- `flip_h = true/false` no `AnimatedSprite2D` é o jeito de espelhar o sprite sem precisar de sprites separados para cada direção


## 2026-06-09 - Aplicando o primeiro sprite e corrigindo algumas coisas do projeto

- Criou a pasta `sprites/Pip/` com os sprites do pinguim (baseado no Sprite Pack 6)
- Extraiu o player para uma cena própria em `entities/player.tscn` com `AnimatedSprite2D`
  usando `AtlasTexture` para recortar os frames do sprite sheet de Idle (5 frames, 16x16)
- Configurou o viewport para 150x100 px com stretch mode `canvas_items` — tamanho adequado
  para pixel art
- Desabilitou o texture filter (`default_texture_filter=0`) para manter o pixel art nítido
- Ajustou SPEED (300 → 30) e JUMP_VELOCITY (-400 → -300) para escalar com o novo viewport menor


## 2026-06-09 - Criando a primeira base de jogo

- Sempre usar o `W` para mover os Nós de objetos com o collision shape
- Estrutura base de um jogo na godot
    - Game [2D_Node_Scene]
        - Player [CharacterBody2D]
            - [CollisionShape2D]
        - Chão [StaticBody2D]
            - [CollisionShape2D]