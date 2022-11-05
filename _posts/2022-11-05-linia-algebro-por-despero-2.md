---
layout: post
title:  "Linia algebro por Despero (parto 2)"
permalink: /blogo/linia-algebro-por-despero-2
---

La dua parto de linialgebra resumo por [despero ludmotoro](/despero). [Parto 1](/blogo/linia-algebro-por-despero-1)

# Utilaj formuloj

* longeco de vektoro

![longeco](/assets/blogo/linia-algebro2/longeco.gif)

* ununormigo de vektoro

![ununormigo](/assets/blogo/linia-algebro2/ununormigo.gif)

(la direkto estas sama, sed la longeco estas **"1"**, _**V**_ != 0)

# Anguloj inter vektoroj

Kiel distingi pozitivajn kaj negativajn angulojn?
1. Neniel. En kelkaj kazoj ni vere zorgas pri angulo **"inter ... kaj ..."**, sed ne angulo **"de ... ĝis ..."**, tiuokaze la signo ne gravas, do ni ne devas difini ĝin.
2. Ni precizigas, ĉirkaŭ kiu akso ni rotacias, kaj difinas, kiu direkto de rotacio respondas al pozitiva rotacio. Ekzemple se rotacio de **e<sub>x</sub>** ĉirkaŭ **e<sub>z</sub>** per **+π/2** rezultiĝas al **e<sub>y</sub>**:

### Sinuso kaj kosinuso

![sincos](/assets/blogo/linia-algebro2/sincos.gif)

La punkto en la supro de la _unuopa_ vektoro, komencanta de la origino, kiu havas angulon _**φ**_ al la X-akso, estas:

![fi](/assets/blogo/linia-algebro2/fi.gif)

Do:

![sinpluscos](/assets/blogo/linia-algebro2/sinpluscos.gif)

### Rotacio en 2D (per matricoj)

Oni diru, ke ni havas rotacion _**R**_ kun angulo _**φ**_ ĉirkaŭ Z-akso:

![rotacio](/assets/blogo/linia-algebro2/rotacio.gif)

1. Unua kolumno estas rezulto de rotacio de **e<sub>x</sub>**
2. Dua kolumno estas rezulto de rotacio de **e<sub>y</sub>**

Se ni havas kelkajn rotaciojn (ekz. _**φ<sub>1</sub>**_ kaj _**φ<sub>2</sub>**_), tiam _**φ**_ = _**φ<sub>1</sub>**_ + _**φ<sub>1</sub>**_:

![matricmultipliko](/assets/blogo/linia-algebro2/matricmultipliko.gif)

![rotacimultipliko](/assets/blogo/linia-algebro2/rotacimultipliko.gif)

Do ni havas sekvajn identecojn:

![identeco1](/assets/blogo/linia-algebro2/identeco1.gif)

![identeco2](/assets/blogo/linia-algebro2/identeco2.gif)

### Komputado de angulo inter du vektoroj

1. Ĉar angulo inter rotataj vektoroj ne ŝanĝiĝas, do ni transformas _**V<sub>1</sub>**_ (kun angulo _**φ<sub>1</sub>**_) al _**e<sub>x</sub>**_ -- intreprena rotacion _**-φ<sub>1</sub>**_ (do **subtraho**):

	![al_e_x](/assets/blogo/linia-algebro2/al_e_x.gif)

	Pruvado:

	![al_e_x_pruvado](/assets/blogo/linia-algebro2/al_e_x_pruvado.gif)

2. Ni komputas angulon inter _**e<sub>x</sub>**_ kaj la turnita _**V<sub>2</sub>**_:

	![komputi_vektoron1](/assets/blogo/linia-algebro2/komputi_vektoron1.gif)
	
	![komputi_vektoron2](/assets/blogo/linia-algebro2/komputi_vektoron2.gif)

	Do:
	
	![skalara](/assets/blogo/linia-algebro2/skalara.gif)

# Orteco

Angulo inter du vektoroj estas orta, se ĝia kosinuso estas 0 (tio estas _**V<sub>1</sub>**_ x _**V<sub>2</sub>**_ = 0).

![orteco](/assets/blogo/linia-algebro2/orteco.gif)

Ni povas malkomponi unu el du vektoroj _**V**_ kaj _**E**_ en du partojn: unua (_**V<sub>p</sub>**_) kun la sama direkto kiel _**E**_ kaj dua (_**V<sub>o</sub>**_) ortan al ĝi. Se \|_**V**_\| = 1, tiam \|_**V<sub>p</sub>**_\| = cosφ.

![paralela](/assets/blogo/linia-algebro2/paralela.gif)

[Parto 3](/blogo/linia-algebro-por-despero-3)
