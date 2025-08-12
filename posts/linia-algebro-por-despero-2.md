---
title: "Linia algebro por Despero (parto 2)"
date: 2022-11-05
---

La dua parto de linialgebra resumo por [flatbox ludmotoro](https://github.com/konceptosociala/flatbox_legacy). [Parto 1](/post/linia-algebro-por-despero-1)

# Utilaj formuloj

* longeco de vektoro

![longeco](/assets/blog/linia-algebro2/longeco.gif)

* ununormigo de vektoro

![ununormigo](/assets/blog/linia-algebro2/ununormigo.gif)

(la direkto estas sama, sed la longeco estas **"1"**, _**V**_ != 0)

# Anguloj inter vektoroj

Kiel distingi pozitivajn kaj negativajn angulojn?
1. Neniel. En kelkaj kazoj ni vere zorgas pri angulo **"inter ... kaj ..."**, sed ne angulo **"de ... ĝis ..."**, tiuokaze la signo ne gravas, do ni ne devas difini ĝin.
2. Ni precizigas, ĉirkaŭ kiu akso ni rotacias, kaj difinas, kiu direkto de rotacio respondas al pozitiva rotacio. Ekzemple se rotacio de **ex** ĉirkaŭ **ez** per **+π/2** rezultiĝas al **ey**:

### Sinuso kaj kosinuso

![sincos](/assets/blog/linia-algebro2/sincos.gif)

La punkto en la supro de la _unuopa_ vektoro, komencanta de la origino, kiu havas angulon _**φ**_ al la X-akso, estas:

![fi](/assets/blog/linia-algebro2/fi.gif)

Do:

![sinpluscos](/assets/blog/linia-algebro2/sinpluscos.gif)

### Rotacio en 2D (per matricoj)

Oni diru, ke ni havas rotacion _**R**_ kun angulo _**φ**_ ĉirkaŭ Z-akso:

![rotacio](/assets/blog/linia-algebro2/rotacio.gif)

1. Unua kolumno estas rezulto de rotacio de **ex**
2. Dua kolumno estas rezulto de rotacio de **ey**

Se ni havas kelkajn rotaciojn (ekz. _**φ1**_ kaj _**φ2**_), tiam _**φ**_ = _**φ1**_ + _**φ1**_:

![matricmultipliko](/assets/blog/linia-algebro2/matricmultipliko.gif)

![rotacimultipliko](/assets/blog/linia-algebro2/rotacimultipliko.gif)

Do ni havas sekvajn identecojn:

![identeco1](/assets/blog/linia-algebro2/identeco1.gif)

![identeco2](/assets/blog/linia-algebro2/identeco2.gif)

### Komputado de angulo inter du vektoroj

1. Ĉar angulo inter rotataj vektoroj ne ŝanĝiĝas, do ni transformas _**V1**_ (kun angulo _**φ1**_) al _**ex**_ -- intreprena rotacion _**-φ1**_ (do **subtraho**)
2. Ni komputas angulon inter _**ex**_ kaj la turnita _**V2**_

# Orteco

Angulo inter du vektoroj estas orta, se ĝia kosinuso estas 0 (tio estas _**V1**_ x _**V2**_ = 0).

![orteco](/assets/blog/linia-algebro2/orteco.gif)

Ni povas malkomponi unu el du vektoroj _**V**_ kaj _**E**_ en du partojn: unua (_**Vp**_) kun la sama direkto kiel _**E**_ kaj dua (_**Vo**_) ortan al ĝi. Se \|_**V**_\| = 1, tiam \|_**Vp**_\| = cosφ.

![paralela](/assets/blog/linia-algebro2/paralela.gif)