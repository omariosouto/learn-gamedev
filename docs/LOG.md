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