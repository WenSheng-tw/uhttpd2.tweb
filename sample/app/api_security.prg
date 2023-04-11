function Api_Security( oDom )

	do case		
		case oDom:GetProc() == 'test1'			; DoTest1( oDom )						
		case oDom:GetProc() == 'test2'			; DoTest2( oDom )								
		
		case oDom:GetProc() == 'test3'			; DoTest3( oDom )								
		case oDom:GetProc() == 'test4'			; DoTest4( oDom )								
		
		//	----------------------------------------------	//
		
		case oDom:GetProc() == 'session_init'	; DoSession_Init( oDom )								
		case oDom:GetProc() == 'session_end'	; DoSession_End( oDom )								
		case oDom:GetProc() == 'session_exist'	; DoSession_Exist( oDom )								
		case oDom:GetProc() == 'session_load'	; DoSession_Load( oDom )								

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc())
	endcase
	
retu oDom:Send()	

// -------------------------------------------------- //

static function DoTest1( oDom )

	local cVar 		:= oDom:Get( 'myvar' )
	local cToken 	:= USetToken( cVar )
	
	local hData 	:= {=>}
	
	hData[ 'original' ] := cVar
	hData[ 'token' ] := cToken
	hData[ 'detoken' ] := UGetToken( cToken )

	oDom:Set( 'mytoken', cToken )
	oDom:Console( hData )
	
retu nil

// -------------------------------------------------- //

static function DoTest2( oDom )

	local cToken 	:= oDom:Get( 'mytoken' )
	local cVar 	:= UGetToken( cToken )					
	
	if cVar == nil 
		oDom:SetMsg( 'Error token !' )
	else
		oDom:SetMsg( cVar, 'Data value' )
	endif
		
retu nil

// -------------------------------------------------- //

static function DoTest3( oDom )
	local hData := {=>}
	local cToken 
	
	hData[ 'name' ] := oDom:Get( 'myname' )
	hData[ 'age'  ] := oDom:Get( 'myage' )
	hData[ 'date' ] := oDom:Get( 'mydate' )
	
	cToken := USetToken( hData )

	oDom:Set( 'mycrypt', cToken )
	oDom:Set( 'mydecrypt', '' )			
	
retu nil

// -------------------------------------------------- //

static function DoTest4( oDom )
	local cToken 	:= oDom:Get( 'mycrypt' )
	local hVar 	:= UGetToken( cToken )		
	local cData 	:= ''
	
	if hVar == nil 	
		cData := '<error token>'
	else
		cData += hVar[ 'name' ] + chr(10)
		cData += hVar[ 'age' ] + chr(10)
		cData += hVar[ 'date' ] 
	endif 
	
	oDom:Set( 'mydecrypt', cData )	
	oDom:Console( hVar )
	
retu nil

// -------------------------------------------------- //


static function DoSession_Init( oDom )
	local hData := {=>}	
	
	hData[ 'name' ] := oDom:Get( 'myname' )
	hData[ 'age'  ] := oDom:Get( 'myage' )
	hData[ 'date' ] := oDom:Get( 'mydate' )
	
	USessionStart()
	Usession( 'data_user'	, hData )
	Usession( 'data_in'		, dtoc( date() ) + ' - ' + time() )
	
	oDom:SetMsg( 'Session created !' )
	
retu nil 

// -------------------------------------------------- //

static function DoSession_End( oDom )
	
	USessionEnd()
		
	oDom:SetMsg( 'Session was deleted !' )
	
retu nil 

// -------------------------------------------------- //

static function DoSession_Exist( oDom )
	
	
	if USessionReady()
		oDom:SetMsg( 'Session exist !' )
	else
		oDom:SetMsg( 'Session NOT exist !' )
	endif
	
retu nil 

// -------------------------------------------------- //

static function DoSession_Load( oDom )

	local hData := {=>}
	local cData := ''

	if USessionReady()
	
		hData := USession( 'data_user' )
		
		cData += hData[ 'name' ] + chr(10)
		cData += hData[ 'age' ] + chr(10)
		cData += hData[ 'date' ] 		

		oDom:Set( 'mysession', cData )		
		
	else 
	
		oDom:Set( 'mysession', 'Session is NULL' )
		
	endif
	
	
retu nil 