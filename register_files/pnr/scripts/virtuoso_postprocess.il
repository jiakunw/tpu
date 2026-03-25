; Rui ("Ray") Xu
; Jan 2022 
; CISL @ Columbia, Kinget Group
; IC 6.1.8 Virtuoso: 7_export.tcl

; This SKILL script is a collection of functions used to post-process the maskLayout generated from Innovus.
; These are called from innovus 7_export.tcl script via a temporary SKILL file generated at runtime.



procedure(getAllInstBboxUnion(myLib myCell myView) 
	; Initialize lists
	LL_X = list()
	LL_Y = list()
	UR_X = list()
	UR_Y = list()

	cvId = dbOpenCellViewByType(myLib myCell myView "maskLayout" "r")
	foreach(box cvId~>instances~>bBox
        LL_X = append1(LL_X xCoord(car(box)))
		LL_Y = append1(LL_Y yCoord(car(box)))
		UR_X = append1(UR_X xCoord(cadr(box)))
		UR_Y = append1(UR_Y yCoord(cadr(box)))

	) ; foreach
	dbClose(cvId)

	; Return value: in the form of ((X, Y) (X, Y)) of the lower-left union and upper-right uniont
	list(list(apply('min LL_X) apply('min LL_Y)) list(apply('max UR_X) apply('max UR_Y)))

) ; procedure


procedure(drawDMEXCL(myLib myCell myView)
	cvId = dbOpenCellViewByType(myLib myCell myView "maskLayout" "a")
	boxUnion = getAllInstBboxUnion(myLib myCell myView)

	; Draw layers
	dbCreateRect(cvId list("DMEXCL" "dummy1") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummy2") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummy3") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummy4") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummy5") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummy6") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummy7") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummy8") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummy9") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummya") boxUnion)
	dbCreateRect(cvId list("DMEXCL" "dummyf") boxUnion)
	dbCreateRect(cvId list("ODBLK" "dummy") boxUnion)
	dbCreateRect(cvId list("POBLK" "dummy") boxUnion)

	dbSave(cvId)
) ; procedure


procedure(changeLabelPurposeToPin(myLib myCell myView)
	cvId = dbOpenCellViewByType(myLib myCell myView "maskLayout" "a")

	foreach(item cvId~>shapes
        if(item~>objType == "label" then
            item~>purpose = "pin"
        ) ; if
	) ; foreach

	dbSave(cvId)
) ; procedure


