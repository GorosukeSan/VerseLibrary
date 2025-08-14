
RealTime<public> := module:

    #v1.0.0
    using { /Verse.org/Simulation }
    
    real_time<public> := struct<concrete>:
        @editable
        Year<public>:int = 0
    
        @editable
        Month<public>:int = 0
    
        @editable
        Day<public>:int = 0
    
        @editable
        Hour<public>:int = 0
    
        @editable
        Minute<public>:int = 0
    
        @editable
        Second<public>:int = 0
    
        @editable
        Millisecond<public>:int = 0
    
        @editable:
            ToolTip := ToolTips.TimeZone
        TimeZone:time_zone = time_zone{}
    
        @editable:
            ToolTip := ToolTips.IsEpochTime
        IsEpochTime<public>:logic = true
    
    
    # タイムゾーンを拡張したい場合はtime_zoneを継承し、[Time<override>:xxx]で秒数を指定してください。
    time_zone<public> := class<computes>:
        Time<public>:float = 0.0
    
    time_zone_gmt<public> := class<computes>(time_zone):
        Time<override>:float = 0.0
    
    time_zone_tokyo<public> := class<computes>(time_zone):
        Time<override>:float = 32400.0
    
    # 呼び出し時点での現在時刻を取得します。
    GetCurrentRealTime<public>(InTimeZone:time_zone)<transacts>:real_time=
        MakeRealTime(GetSecondsSinceEpoch(), InTimeZone)
    
    # float型からreal_time型に変換します。
    MakeRealTime<public>(InEpochTime:float, InTimeZone:time_zone, ?IsEpochTime:logic = true)<transacts>:real_time=
        CurrentTime := Max(InEpochTime + InTimeZone.Time, 0.0)
    
        EpochTimeSeconds := 
            if(Result := Floor[CurrentTime]):
                Result
            else:
                0
    
        Millisecond := 
            if(Result := Mod[Floor[CurrentTime * 1000], 1000]):
                Result
            else:
                0
    
        Seconds := 
            if(Result := Mod[EpochTimeSeconds, 60]):
                Result
            else:
                0
    
        Minutes :=
            if(Result := Mod[Floor(EpochTimeSeconds / 60), 60]):
                Result
            else:
                0
    
        Hours :=
            if(Result := Mod[Floor(EpochTimeSeconds / (60*60)), 24]):
                Result
            else:
                0
    
        Days :=
            if(Result := Floor(EpochTimeSeconds / (60*60*24))):
                Result
            else:
                0
    
        var Years:int = 
            if(IsEpochTime?):
                1970
            else:
                0
        var TotalDays:int = Days
        loop:
            DaysInYear := 
                if(IsLeapYear[Years]):
                    366
                else:
                    365
            if(TotalDays >= DaysInYear):
                set TotalDays -= DaysInYear
                set Years += 1
            else:
                break
    
        var Month:int = 0
        loop:
            if(var DaysInMonth : int = DaysInMohth[Month]):
                if(Month = 2, IsLeapYear[Years]):
                    set DaysInMonth = 29
                
                if(TotalDays >= DaysInMonth):
                    set TotalDays -= DaysInMonth
                    set Month += 1
                else:
                    break
            else:
                break
    
        if(IsEpochTime?):
            real_time:
                Year := Years
                Month := Month + 1
                Day := TotalDays + 1
                Hour := Hours
                Minute := Minutes
                Second := Seconds
                Millisecond := Millisecond
                TimeZone := InTimeZone
                IsEpochTime := IsEpochTime
        else:
            real_time:
                Year := Years
                Month := Month
                Day := TotalDays
                Hour := Hours
                Minute := Minutes
                Second := Seconds
                Millisecond := Millisecond
                TimeZone := InTimeZone
                IsEpochTime := false
    
    # float型からreal_time型に変換します。
    (InRealTime:real_time).ToFloat<public>()<transacts>:float=
        var TotalDays:int = 0
        StartYear := 
            if(InRealTime.IsEpochTime?):
                1970
            else:
                0
        for:
            Year := StartYear..InRealTime.Year - 1
        do:
            set TotalDays += 
                if(IsLeapYear[Year]):
                    366
                else:
                    365
        for:
            CurrentMonth := 0..InRealTime.Month - 
                if(Value := InRealTime.IsEpochTime?):
                    2
                else:
                    1
            DaysInMonth := DaysInMohth[CurrentMonth]
        do:
            set TotalDays += DaysInMonth
            if(CurrentMonth = 1, IsLeapYear[InRealTime.Year]):
                set TotalDays += 1
        
        var TotalSeconds:float = (TotalDays * (24 * 60 * 60)) * 1.0
        set TotalSeconds += 
            if(InRealTime.IsEpochTime?):
                ((InRealTime.Day - 1) * (24 * 60 * 60)) * 1.0
            else:
                (InRealTime.Day * (24 * 60 * 60)) * 1.0
        set TotalSeconds += (InRealTime.Hour * (60 * 60)) * 1.0
        set TotalSeconds += (InRealTime.Minute * 60) * 1.0
        set TotalSeconds += InRealTime.Second * 1.0
        set TotalSeconds += (InRealTime.Millisecond*1.0) / 1000.0
        Max(TotalSeconds - InRealTime.TimeZone.Time, 0.0)
    
    (InRealTime:real_time).Adjust<public>()<transacts>:real_time=
        FloatTime := InRealTime.ToFloat()
        MakeRealTime(FloatTime, InRealTime.TimeZone, ?IsEpochTime:=InRealTime.IsEpochTime)
    
    (InRealTime:real_time).ToTimeZoneFloat<public>()<transacts>:float=
        InRealTime.ToFloat() + InRealTime.TimeZone.Time
    
    IsEqual<public>(X:real_time, Y:real_time)<decides><transacts>:void=
        X.ToFloat() = Y.ToFloat()
    
    GreaterThan<public>(X:real_time, Y:real_time)<decides><transacts>:void=
        X.ToFloat() > Y.ToFloat()
    
    EqualOrGreaterThan<public>(X:real_time, Y:real_time)<decides><transacts>:void=
        X.ToFloat() >= Y.ToFloat()
    
    LessThan<public>(X:real_time, Y:real_time)<decides><transacts>:void=
        X.ToFloat() < Y.ToFloat()
    
    EqualOrLessThan<public>(X:real_time, Y:real_time)<decides><transacts>:void=
        X.ToFloat() <= Y.ToFloat()
    
    Distance<public>(X:real_time, Y:real_time)<decides><transacts>:real_time=
        X.IsEpochTime = Y.IsEpochTime
        Result := Max(X.ToFloat(), Y.ToFloat()) - Min(X.ToFloat(), Y.ToFloat())
        MakeRealTime(Result, time_zone{}, ?IsEpochTime:=false)
    
    operator'+'<public>(X:real_time, Y:real_time)<transacts>:real_time=
        Result := X.ToFloat() + Y.ToFloat()
        MakeRealTime(Result, X.TimeZone, ?IsEpochTime:=X.IsEpochTime)
    
    operator'-'<public>(X:real_time, Y:real_time)<transacts>:real_time=
        Result := X.ToFloat() - Y.ToFloat()
        MakeRealTime(Result, X.TimeZone, ?IsEpochTime:=X.IsEpochTime)
    
    ToString<public>(InRealTime:real_time)<reads>:string=
        "{InRealTime.Year}年{InRealTime.Month}月{InRealTime.Day}日\n{InRealTime.Hour}時{InRealTime.Minute}分{InRealTime.Second}秒"
    
    DaysInMohth<public>:[]int = array{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    
    IsLeapYear<public>(InYear:int)<decides><transacts>:void=
        (Mod[InYear, 4] = 0, Mod[InYear, 100] <> 0) or (Mod[InYear, 400] = 0)
    
    ToolTips<public> := module:
        TimeZone<public><localizes>:message=
            "time_zoneクラスを継承したクラスを選択することで、計算時にそのタイムゾーンでオフセットされます。"
        IsEpochTime<public><localizes>:message=
            "この時間がエポック時間（1970年1月1日）からの経過時間であるかどうかを示します。"
