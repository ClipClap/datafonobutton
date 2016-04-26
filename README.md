
## ccccc Framework  para iOS##

ClipClap te permite incorporar la acción de crear cuentas de cobro desde tu aplicación iOS de forma fácil y rápida. Solo debes hacer uso de este framework en tu aplicación.
Te recordamos que para poder realizar la integración debes descargar la aplicación de Datáfono ClipClap desde la AppStore.

## Prerrequisitos ##

 1. ***Tener una cuenta ClipClap Datáfono:***
Para poder realizar la integración con ClipClap debes primero tener una cuenta en ClipClap Datáfono, puedes hacer el proceso de registro siguiendo este [link](https://clipclap.co/) o desde la misma aplicación.

 2. **ClipClap Billetera para tus clientes:**
Para que tus usuarios reciban las cuentas de cobro deben tener instalada la aplicación Billetera ClipClap, esta permitirá realizar los pagos de forma rápida y segura para tus clientes.


## Integración ##

Sigue los siguientes pasos para conocer cómo se debe integrar el framework de creación de cuentas de cobro en tu aplicación iOS con Xcode 7 o superior:

**Paso 1: En el proyecto de Xcode de tu aplicación integra el framework así:**


![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_6.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_7.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_8.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_9.png)

**Paso 1.1: Para que DatafonoButton.framework pueda saber si la aplicación de Datáfono ClipClap está instalada en tu dispositivo. (solo iOS 9 o superior)**

En en el "*info.plist*" de su aplicación agregue:

    <key>LSApplicationQueriesSchemes</key>
	<array>
		<string>ClipClapDatafono</string>
	</array>

> ***IMPORTANTE:*** En iOS 9 o superior es necesario colocar el URL Scheme de Datáfono ClipClap en la lista blanca de Schemes de tu aplicación, de lo contrario Datáfono ClipClap no se abrirá.

**Paso 2: Configurar el cobro.**

En  la clase donde vas a usar ClipClapCharge framework:

    #import <CCDatafonoButton/CCDatafonoButton.h>
    
Hay dos forma de crear un cobro para que ClipClap Billetera lo gestione:

 1) *Forma 'producto por producto':* Esta opción permite agregar al cobro productos de forma individual especificando su nombre, precio, cantidad y el impuesto que se le aplica al producto. Así: 
    
    //Creando un objeto CCBPayment con un ID de referencia único.
    CCBPayment *cobro = [[CCBPayment alloc] initWithPaymentReference:YOUR_ID_REFERENCE];
    
    //Para cada producto haga esto:
    NSString *nombreProducto = @"Camisa Polo";
    int precio = 25000;
    int cantidad = 3;
      
    [cobro addItemWithName:nombreProducto 
					 value:precio 
					 count:cantidad  
		       andTaxType:kCCBilleteraTaxTypeIVARegular];

2) *Forma 'total-impuesto-propina':* Esta opción permite definir el total a cobrar de forma inmediata especificando el total a cobrar sin impuestos, el impuesto sobre el total y de forma opcional la propina. Así:

    //Creando un objeto CCBPayment con un ID de referencia único.
    CCBPayment *cobro = [[CCBPayment alloc] initWithPaymentReference:YOUR_ID_REFERENCE];
    
    NSString *descripción = @"Dos perros calientes y una gaseosa";
    int totalSinImpuesto = 20000;
    int impuesto = 1600; //Se aplicó Consumo Regular del 8% sobre el total sin impuesto.
    int propina = 2000 //Esto es opcional.
    
    //Use este método para NO incluir propina.
    [cobro addTotalWithValue:totalSinImpuesto
                         tax:impuesto
              andDescription:descripción];
                                           
    //Use este método para SI incluir propina.
    [cobro addTotalWithValue:totalSinImpuesto
                         tax:impuesto
                         tip:propina
              andDescription:descripción];

> ***Nota:*** Estas dos formas de crear el cobro son mutuamente excluyentes. Si usted utiliza ambas formas al mismo tiempo, la *forma 'total-impuesto-propina'* prevalece sobre la *forma 'producto-por-producto'*.

> ***Nota:*** Si en su cuenta de ClipClap Datáfono tiene lo opción de propina inhabilitada, la opción de pagar con propina NO aparecerá en ClipClap Billetera.
> 
> ***IMPORTANTE:*** YOUR_ID_REFERENCE debe ser diferente cada vez que intente hacer un cobro nuevo.

**Paso 4: Decirle a ClipClap Billetera que realice el cobro**

    //Obteniendo de ClipClap un token único para este cobro. Hasta este momento todavía el cobro no se ha hecho efectivo.
    [[CCBPaymentHandler shareInstance] 
							 getPaymentTokenWithBlock:^(NSString *token, NSError *error){    
        if (error)
        {
            //Aqui debe mostrarse al usuario que hubo problemas para realizar el pago.
        }
        else
        {
            //Antes de hacer efectivo el cobro con el 'token' obtenido, usted debe guardar
            //éste en su sistema de información.
            
            //Después de guardado el ´token´ se procede a llamar a ClipClap Billetera
            //para que gestione el cobro.
             [[CCBPaymentHandler shareInstance] commitPaymentWithToken:token 
									          andBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    //Mostrar al usuario que el pago se realizó con éxito.
                }
                else
                {
                    if (error.code == kCCBilleteraPaymentErrorTypeRejected)
                    {
	                    //Mostrar al usuario que el pago fue rechazado.
                    }
                    else if (error.code == kCCBilleteraPaymentErrorTypeRejected)
                    {
	                    //error.userInfo[@"error"] contiene la razón del fallo del pago.
	                    //Mostrar al usuario que hubo un error realizando el pago.
                    }
                }
            }];
        }
    }];

> ***IMPORTANTE:*** Es recomendable guardar el 'token' ya que con éste usted puede relacionar el cobro realizado con su propio sistema de información.


## Tipos de impuesto ##

    kCCBilleteraTaxTypeIVARegular => IVA Regular del 16%.
    kCCBilleteraTaxTypeIVAReducido => IVA Reducido del 5%.
    kCCBilleteraTaxTypeIVAExcento => IVA Excento del 0%.
    kCCBilleteraTaxTypeIVAExcluido => IVA Excluido del 0%.
    kCCBilleteraTaxTypeConsumoRegular => Consumo Regular 8%.
    kCCBilleteraTaxTypeConsumoReducido => Consumo Reducido 4%.
    kCCBilleteraTaxTypeIVAAmpliado => IVA Ampliado 20%.

## Tipos de error ##

    kCCBilleteraPaymentErrorTypeRejected => El cliente rechazó el pago.
    kCCBilleteraPaymentErrorTypeFailed => El cliente intentó pagar pero hubo en error.


## IOSParkingAppSample demo app ##

Para que este Demo funcione correctamente en iOS 9 o superior debe configurar el Demo para que trabaje con Universal Links. Visite esta guía para aprender cómo configurar Universal Links en iOS. https://developer.apple.com/library/ios/documentation/General/Conceptual/AppSearch/UniversalLinks.html