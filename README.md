# SIM Practice 1 (exercise 2: artillery cannon with numerical integration methods in simulation).
Simulation subject within the Multimedia Engineering degree from the ETSE - Universitat de València. March 2022. Practice 1, exercise 2. Rating 8.5.

An inclined plane had to be simulated with a mass, also inclined, subject to the force of two springs, using numerical integration methods.

🎞️ Vídeo with the result: https://www.youtube.com/watch?v=UhIxfp2Bars

![Descriptive image of the exercise.](https://github.com/ximo99/SIM-practice1-ex2/blob/main/ex2-photo.jpg)

### ENGLISH
Consider an artillery cannon located in a coastal fort. The cannon launches a ballistic projectile of mass 𝑚, which is launched from a fixed elevated position with the aim of hitting a ship at a distance 𝐷, although it can also fall into the sea. The projectile is fired with speed 𝑣0 and with an angle 𝜃 with respect to the horizontal. In addition to gravity 𝑔, there will be friction with the air that we will assume is linearly proportional to the speed (although this is a simplification of what happens in reality), with a proportionality factor that we will call 𝐾𝑑𝑎. If the projectile falls into water, there will also be friction (greater than with air) and the friction constant will be 𝐾𝑑𝑤.

The projectile will initially be located in position 𝑠0. Due to its initial velocity (𝑣0) and gravity, it will begin to move. The initial position 𝑠0 will be set by the height of the launching point above the water, which we will call ℎ𝑤. We will assume that the water is at a height of 0, and also that the projectile is initially located on the Y axis, as can be seen in the figure.

### ESPAÑOL
Considerando una partícula de masa 𝑚, ubicada en un plano inclinado, cuya inclinación es 𝜃 grados, y cuya longitud es 𝐿. La partícula se mantiene en ambos extremos del plano inclinado mediante dos resortes. Cada uno de los dos resortes tiene una constante de resorte y un alargamiento en reposo diferentes.

En un resorte, cuando su alargamiento es menor que el alargamiento en reposo, el resorte se expande debido a la acción de la fuerza elástica; Cuando es mayor, el resorte se comprime. La partícula se ubicará inicialmente en el punto medio del plano inclinado, y debido a las fuerzas elásticas y a la fuerza del peso provocada por la gravedad comenzará a acelerar con aceleración 𝑎 y a moverse con velocidad 𝑣, modificando su posición 𝑠. También habrá una fuerza normal, que contrarrestará el efecto de la fuerza del peso en dirección perpendicular al plano y evitará que la partícula lo atraviese.

Además, la partícula se verá frenada por la fricción con el aire, lo que hará que pierda energía. Supondremos que la magnitud de la fuerza de fricción será proporcional al cuadrado de la velocidad, con un factor de proporcionalidad. También habrá fricción entre la partícula y el plano, cuya magnitud será linealmente proporcional a la fuerza normal, con un factor de proporcionalidad.
