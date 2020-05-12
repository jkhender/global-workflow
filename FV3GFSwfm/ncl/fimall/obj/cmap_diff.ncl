function gen_colormap( )
begin
        ;This procedure explicitly sets the red, green, and blue
        ;intensities for each element in a colormap array.
        ;
        return( (/ (/.000,.000,.000/), \   ; 0 (background)
                (/1.000,1.000,1.000/), \   ; 1 (foreground)
                (/1.000,.200,.000/), \     ; 3
                (/1.000,.400,.200/), \     ; 3
                (/1.000,.600,.400/), \      ; 4
                (/1.000,.800,.500/), \      ; 5
                (/.000,.900,1.000/), \      ; 6
                (/.000,.750,1.000/), \     ; 7
                (/.000,.500,1.000/), \     ; 8
                (/.000,.350,1.000/), \     ; 9
                (/1.000,1.000,1.000/), \   ; 10
                (/.100,.600,.000/), \      ; 11
                (/.100,.850,.000/), \      ; 12
                (/.375,1.000,.000/), \     ; 13
                (/.500,.850,.000/), \      ; 14
                (/.625,.700,.000/), \      ; 15
                (/.750,.800,.000/), \      ; 16
                (/.875,.900,.000/), \      ; 17
                (/1.000,.900,.000/), \     ; 18
                (/.400,.400,.400/), \      ; 19
                (/.500,.500,.500/) /) )    ; 20
end
