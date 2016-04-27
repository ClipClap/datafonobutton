
## CCDatafonoButton Framework  para iOS##

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


![enter image description here](https://clipclap.co/docs/tutorials/ios/images/datafonoboton/slide_1.png)

![enter image description here](https://clipclap.co/docs/tutorials/ios/images/datafonoboton/slide_2.png)

![enter image description here](https://clipclap.co/docs/tutorials/ios/images/datafonoboton/slide_3.png)

![enter image description here](https://clipclap.co/docs/tutorials/ios/images/datafonoboton/slide_4.png)

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
    
Creando la cuenta de cobro e invocando a Datáfono ClipClap para que gestione el cobro:
    
    //Creando un objeto CCBPayment.
    CCDBPayment *cobro = [[CCDBPayment alloc] init];
    
    //Agregando tres perros calientes a la cuenta cobro.
    [cobro addItemWithName:@"Perro Caliente" value:20000 andCount:3];
    
	//Agregando dos hamburguesas a la cuenta cobro.
    [cobro addItemWithName:@"Hamburguesa" value:20000 andCount:2];
    
	//Abriendo Datáfono ClipClap para que gestione el cobro.
    [CCDBHandler shareInstance] commitPayment:payment];


## BotonDatafono demo app ##

En este demo puede ver en acción el uso del CCDatafonoButton framework.