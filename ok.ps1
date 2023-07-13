Import-Module ActiveDirectory
$usuarios = Import-Csv 'total_alterados.txt' -Delimiter ";"
$password = "SeSDF135#"

$OU_FINAL = "OU=Servidores,OU=Usuarios,OU=IHBDF,OU=SES-DF,DC=saude,DC=df,DC=gov,DC=br"
$i = 1
foreach($usu in $usuarios){
    $matricula = $usu.matricula
  #  Set-ADAccountPassword -Identity "$matricula" -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force) -PassThru | Enable-ADAccount 
    $usuario = Get-ADUser -F { SamAccountName -eq $matricula} -Properties Name,UserPrincipalName, SamAccountName, Enabled, DistinguishedName
    $nome = $usuario.Name
    $nomePrincipal =  $usuario.UserPrincipalName
    $nomeDaConta = $usuario.SamAccountName    
    $ou = ($usuario.DistinguishedName -split ",", 2)[1]
  #  $nomePrincipal
    
   # $usuTemp = Get-ADUser -F { Name -eq $nome} -Properties Name,UserPrincipalName, SamAccountName, Enabled, DistinguishedName -SearchBase $OU_FINAL
   # $nomePrincipal
    if($nomePrincipal -notlike "552*"){
      # $nomePrincipal
        $m = $matricula
        if ($matricula.Length -eq 8){ 
			$m = -join("552",$matricula)            
            $nomePrincipalTemp = -join($m,"@saude.df.gov.br")
            $matricula
            $u = Get-ADUser -Identity $matricula 
            Set-ADUser -Identity $u -UserPrincipalName $nomePrincipalTemp
            $u.UserPrincipalName
          #  $u
            $i +=1
			#Write-Host "asdas $matricula"
		}elseif($matricula.Length -eq 7){	
			$m = -join("5520",$matricula)            
            $nomePrincipalTemp = -join($m,"@saude.df.gov.br")
           # $nomePrincipal -replace $nomePrincipal,$nomePrincipalTemp
            $u = Get-ADUser -Identity $matricula 
            Set-ADUser -Identity $u -UserPrincipalName $nomePrincipalTemp
          #  $u
          #  $matricula
          #  $u = Get-ADUser -Identity $matricula
            $u.UserPrincipalName
            $i +=1
		#	Write-Host "asdas $matricula"
		}elseif($matricula.Lenght -eq 6){	
			$m = -join("55200",$matricula)            
            $nomePrincipalTemp = -join($m,"@saude.df.gov.br")
           # $nomePrincipal -replace $nomePrincipal,$nomePrincipalTemp
            $u = Get-ADUser -Identity $matricula 
            Set-ADUser -Identity $u -UserPrincipalName $nomePrincipalTemp
            $u.UserPrincipalName
            $i +=1
		}	
     # $nomePrincipalTemp
        
      #  $matricula	
       # $i +=1
       "========================"
    }

    #COMPARA SE JA EXISTE OUTRO USUARIO COM MSM NOME EM UMA OU
    if($ou -ne $OU_FINAL){
        
      #  $usuTemp = Get-ADUser -F { Name -eq $nome} -Properties Name,UserPrincipalName, SamAccountName, Enabled, DistinguishedName -SearchBase $OU_FINAL
        if($usuTemp){
            $n = $nome+"."
           # $n
            $usuario | Rename-ADObject -NewName $n | Move-ADObject -TargetPath $OU_FINAL
            "USUARIO JA EXISTE NA OU"
        }
        $usuario | Move-ADObject -TargetPath $OU_FINAL
        "===================="
    }
   
}
$i