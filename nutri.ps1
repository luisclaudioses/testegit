Import-Module ActiveDirectory
$usuarios = Import-Csv '.\NUTRI.csv' -Delimiter ";"

function writeLogNutri($usuarioTemp){
   $tempLogin = $usuarioTemp.SamAccountName

    foreach($usuarioT in $usuarioTemp){     
        $usuarioT.SamAccountName 
       
        if($usuarioT.enabled -eq $True){
	        Add-Content C:\nutricao_final.csv "$nome;$cpf;$matricula;$especialidade;$cargo;$carreira;$lotacao;$status;$tempLogin"
        }
    }
}

function getUser{
    param(
        [string]$Field,
        [string]$Value
    )
    
    $u =  Get-ADUser -Filter {Enabled -eq $true -and $Field -eq $Value} | Select-object Name,UserPrincipalName, SamAccountName, Enabled
    return $u
}
foreach($usuario in $usuarios){
    $matricula = $usuario.matricula
    $nome = $usuario.nome
    $cpf = $usuario.cpf
    $especialidade = $usuario.especialidade
    $cargo = $usuario.cargo
    $carreira = $usuario.carreira
    $lotacao = $usuario.lotacao
    $status = $usuario.status
    #Write-Host "$matricula,$nome"n 
    
    #Busca por matricula
    $usuarioTemp = getUser -Field "SamAccountName" -Value $matricula
    if($usuarioTemp){
        Write-Host "Entrou no IF $matricula"
        writeLogNutri($usuarioTemp)
	}else{
        
        Write-Host "Entrou no ELSE $matricula"
        $usuarioTemp = getUser -Field "SamAccountName" -Value $cpf   
        if($usuarioTemp){
            writeLogNutri($usuarioTemp)
        } else{  
            $usuarioTemp = getUser -Field "Name" -Value $nome   
            if($usuarioTemp){                
                writeLogNutri($usuarioTemp)
            }else{
                Write-Host "NAO ENCONTRADO $matricula;$nome;$cpf"
            }
        } 
	}
    
}