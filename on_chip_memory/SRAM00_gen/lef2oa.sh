# 先删除旧的 oalib
rm -rf ./sram00_oalib
# Step 1: 建目录
mkdir -p ./sram00_oalib

# Step 2: 重新运行（参数不变，用 tsmcN65）
rm -rf ./sram00_oalib/sram00/abstract

# LAYERMAP=/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/Base_PDK/PDK_CRN65GP_v1.0c_official_IC61_20101010/Techfile/1p9m_6X2Z0U/techfile_lib/tsmcN65/tsmcN65.layermap
#tcbn65gplus_oatech   tsmcN65
# lef2oa 用 tcbn65gplus_oatech（DBU=2000）+ layerMap 指定层映射
lef2oa \
    -lef ./sram00.vclef \
    -lib sram00_oalib \
    -libPath ./sram00_oalib \
    -techLib  tsmcN65\
    -overwrite \
    -dataModel 4 \
    -logFile ./lef2oa.log

grep -E "ERROR|WARNING" ./lef2oa.log | head -20

strmin \
    -library sram00_oalib \
    -strmFile ./sram00.gds2 \
    -layerMap /courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/Base_PDK/PDK_CRN65GP_v1.0c_official_IC61_20101010/Techfile/1p9m_6X2Z0U/techfile_lib/tsmcN65/tsmcN65.layermap \
    -dbuPerUU 2000 \
    -logFile ./strmin.log

grep -E "Polygons|Rectangles|Text|error" ./strmin.log



XScale -mag 2 -lib sram00_oalib -cell sram00  -view abstract

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