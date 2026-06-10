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