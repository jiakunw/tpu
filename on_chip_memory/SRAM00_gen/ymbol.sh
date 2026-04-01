cat > ./gen_symbol.il << 'EOF'

procedure( genSymbolFromAbstract(libName cellName)
    let( (abCv pinList termList) 
        abCv = dbOpenCellView(libName cellName "abstract" "r")
        
        if(abCv then
            termList = abCv~>terminals
            pinList = list(
                nil
                'ports
                mapcar(
                    lambda((term)
                        list(
                            nil
                            'name term~>name
                            'direction 
                            case(term~>direction
                                ("input" "input")
                                ("output" "output")
                                ("inputOutput" "inout")
                                (t "inout")  
                            )
                        )
                    )
                    termList
                )
            )
            
            printf("Found %d pins:\n" length(termList))
            foreach(term termList
                printf("  %s (%s)\n" term~>name term~>direction)
            )
            
            if(schPinListToSymbolGen(libName cellName "symbol" pinList) then
                printf("Symbol view created successfully for %s/%s\n" libName cellName)
            else
                printf("ERROR: Failed to create symbol view\n")
            )
            
            dbClose(abCv)
        else
            printf("ERROR: Cannot open abstract view for %s/%s\n" libName cellName)
        )
    )
)

genSymbolFromAbstract("sram00_oalib" "sram00")

exit
EOF

virtuoso -nograph -replay ./gen_symbol.il