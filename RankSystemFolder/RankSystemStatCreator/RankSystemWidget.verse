using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Fortnite.com/UI }

MakeRankSystemWidget<public><constructor>(InPlayer:player, InDesign:rank_design)<transacts> := rank_system_widget:

    block:
        if(rank_system_icon_color_block[InDesign.Icon]):
            Print("warning: 警告、Design.Iconでcolor_blockが選択されている状態です。[rank_system_icon_color_block]をクリックして[rank_system_icon_texture_block]に変更することを推奨します。", ?Duration:=60.0)

    Player := InPlayer
    Design := InDesign
    Icon := InDesign.Icon.GetWidget()
    Background := InDesign.Background.GetWidget()
    Name := InDesign.Name.GetWidget()
    Progress := InDesign.Progress.GetWidget()
    ProgressBar := 
        option:
            Result := InDesign.ProgressBar?
            MakeProgressBarWidget(Result)

MakeProgressBarWidget<public><constructor>(InDesign:rank_system_progress_bar)<transacts> := progress_bar_widget:

    Front := color_block:
        DefaultColor := InDesign.FrontColor
        DefaultDesiredSize := ToVector2(InDesign.Size)
    Background := color_block:
        DefaultColor := InDesign.BackgroundColor
        DefaultDesiredSize := ToVector2(InDesign.Size)
    Frame<public> := color_block:
        DefaultColor := InDesign.FrameColor
        DefaultDesiredSize := ToVector2(InDesign.Size) + vector2{X := InDesign.Padding.Left, Y := InDesign.Padding.Top}
    Info := InDesign

progress_bar_widget<public> := class(widget_part_interface):
    Front<public>:color_block
    Background<public>:color_block
    Frame<public>:color_block
    Info<public>:rank_system_progress_bar

    Show<public>():void=
        Front.SetVisibility(widget_visibility.Visible)
        Background.SetVisibility(widget_visibility.Visible)
        Frame.SetVisibility(widget_visibility.Visible)

    Hide<public>():void=
        Front.SetVisibility(widget_visibility.Collapsed)
        Background.SetVisibility(widget_visibility.Collapsed)
        Frame.SetVisibility(widget_visibility.Collapsed)

    SetPercent<public>(InPercent:float):void=
        XAmount := Info.Size.X * InPercent
        Front.SetDesiredSize(vector2{X := XAmount, Y := Info.Size.Y})

    GetWidget<override>()<transacts>:widget=
        overlay:
            Slots := array:
                overlay_slot:
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Widget := Frame
                overlay_slot:
                    Padding := Info.Padding.GetMargin()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Fill
                    Widget := Background
                overlay_slot:
                    Padding := Info.Padding.GetMargin()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Fill
                    Widget := Front

rank_system_widget<public> := class<final>(common_widget_base):

    Design<public>:rank_design
    Background<public>:widget
    Icon<public>:widget
    Name<public>:widget
    Progress<public>:widget
    ProgressBar<public>:?progress_bar_widget

    NameToMessage<private><localizes>(InName:string):message="{InName}"
    ProgressToMessage<private><localizes>(Current:int, Next:int):message="{Current} / {Next}"
    NumberToMessage<private><localizes>(Current:int):message="{Current}"

    UpdateIcon<public>(InImage:texture):void=
        if(TextureBlock := texture_block[Icon]):
            TextureBlock.SetImage(InImage)

    UpdateText<public>(InName:string):void=
        if(TextBlock := text_block[Name]):
            TextBlock.SetText(NameToMessage(InName))

    UpdateProgress<public>(InCurrent:int, InPrev:int, InNext:?int):void=
        if(TextBlock := text_block[Progress]):
            if(ActiveNext := InNext?):
                TextBlock.SetText(ProgressToMessage(InCurrent, ActiveNext))
            else:
                TextBlock.SetText(NumberToMessage(InCurrent))

        if(ActiveProgressBar := ProgressBar?):
            if(ActiveNext := InNext?):
                CurrentDiff := InCurrent - InPrev
                NextDiff := ActiveNext - InPrev
                Percent := (CurrentDiff*1.0) / (NextDiff*1.0)
                ActiveProgressBar.Show()
                ActiveProgressBar.SetPercent(Percent)
            else:
                ActiveProgressBar.Hide()

    CreateCanvas<override>():canvas=
        canvas:
            Slots := array:
                canvas_slot:
                    Anchors := Design.Anchors.GetAnchors()
                    Offsets := Design.Offsets.GetOffsets()
                    Alignment := Design.Alignment
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                Widget := Design.Background.GetWidget()
                            overlay_slot:
                                Widget := Icon
                                Padding := Design.IconPosition.GetMargin()
                            if(ActiveProgressBar := ProgressBar?):
                                overlay_slot:
                                    Widget := ActiveProgressBar.GetWidget()
                                    Padding := ActiveProgressBar.Info.Position.GetMargin()
                            else:
                                # 空データ
                                overlay_slot:
                                    Widget := text_block{}
                            overlay_slot:
                                Widget := Name
                                Padding := Design.NamePosition.GetMargin()
                            overlay_slot:
                                Widget := Progress
                                Padding := Design.ProgressPosition.GetMargin()