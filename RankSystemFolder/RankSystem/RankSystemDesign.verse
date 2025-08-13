using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }

rank_design<public> := class:
    @editable
    Anchors<public>:rank_system_anchors = rank_system_anchors_normalized{Position := normalized_vector2{X := 0.1, Y := 0.5}}
    @editable
    Offsets<public>:rank_system_offsets = rank_system_offsets_screen_size{}
    @editable_vector_slider(float):
        MinComponentValue := option{0.0}
        MaxComponentValue := option{1.0}
    Alignment<public>:vector2 = vector2{X := 0.5, Y := 0.5}

    @editable
    Background<public>:rank_system_icon = rank_system_icon_color_block{Size := vector2{X := 256.0, Y := 256.0}}
    @editable
    Icon<public>:rank_system_icon = rank_system_icon_color_block{}
    @editable
    IconPosition<public>:rank_system_position = rank_system_position{}

    @editable
    Name<public>:rank_system_text_block = rank_system_text_block{TextSize := 32.0}
    @editable
    NamePosition<public>:rank_system_position = rank_system_position{Y := -100.0}

    @editable
    Progress<public>:rank_system_text_block = rank_system_text_block{}
    @editable
    ProgressPosition<public>:rank_system_position = rank_system_position{Y := 100.0}

    @editable
    ProgressBar<public>:?rank_system_progress_bar = option:
        rank_system_progress_bar{Position := rank_system_position{Y := 100.0}}