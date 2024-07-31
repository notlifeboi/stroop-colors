<h1 align="center">Stroop Colors</h1>
<p align="center">Aplicación desarrollada en el framework Flutter basada en el efecto Stroop, la aplicación incluye un menú para empezar el juego, sistema de puntajes y un modo para configurar tu propia partida personalizada o empezar una partida contrarreloj</p>

<h2>Efecto Stroop</h2>
<p>El efecto Stroop, es una interferencia semántica que se da a causa de tener automatizada la lectura, haciendo que demos prioridad, inconscientemente, aquellos estímulos que vengan en forma de palabras escritas antes que en otras modalidades, como pueden ser forma o color. Por ejemplo, la palabra ‘AZUL’ está pintada de color amarillo, la palabra ‘VERDE’ viene pintada de color rojo, y así sucesivamente.</p>

<b>Fuentes: https://psicologiaymente.com/psicologia/efecto-stroop</b>

Se utiliza este efecto como base del juego, ya que por medio de esta aplicación didáctica se recrea este efecto de manera que los usuarios cuando empiecen su juego, encuentren varias palabras mostrando un color distinto al que tienen escrito, y a continuación 4 opciones para seleccionar el color correcto. Se incluye un contador de palabras totales, palabras acertadas e incorrectas para poder conocer nuestro progreso en cada partida que juguemos</p>

<h2>Requisitos</h2>
<ul>
  <li>Entorno de desarrollo (Visual Studio Code o Android Studio preferiblemente)</li>
  <li>Framework Flutter (Instalado)</li>
  <li>Consola Git Bash o CMD</li>
</ul>

<h2>Ejecución de la aplicación</h2>
<p>
  <ol>
  <b><li>Clona el repositorio</li></b>
    <p>Abre tu consola de Github o CMD, a continuación ubicate en la ruta de la carpeta donde vas a clonar el repositorio. Ahora escribe el siguiente comando: </p>
    <pre><code>git clone https://github.com/notlifeboi/stroop-colors.git</code></pre>
  <b><li>Abre el repositorio clonado</li></b>
    <p>Una vez tengas tu repositorio clonado, abrelo desde tu entorno de desarrollo, ya sea Visual Studio Code o Android Studio. Tener en cuenta que ambos entornos tienen sus     independencias que deben ser instaladas para que pueda correr la aplicación</p>
  <b><li>Corre el proyecto</li></b>
    <p>Corre el proyecto dando click al botón de debug correspondiente a tu entorno de desarrollo, en caso de que utilices Android Studio deberás descargar una máquina            virtual o bien, correr el proyecto en tu propio celular. Para Visual, tendrás la opción de correrlo desde tu navegador Chrome o Edge</p>
  </ol>
</p>

<h2>Funcionamiento de la aplicación</h2>
<p>Conoce las funcionalidades de la aplicación para que te orientes en el código (La mayoria de este está documentado para que sepas qué hace cada cosa)</p>
  <ul>
    <b><li>Main.dart</li></b>
    <p>Se crea la pantalla de carga inicial, y se define el home que en este caso será menu.dart</p>
    <b><li>Menu.dart</li></b>
    <p>Päntalla inicial de nuestra aplicación, con botones de redirección al leaderboard o puntuaciones locales del usuario, coniguración de juego personalizado o iniciar el      juego el modo normal (Vanilla)</p>
    <b><li>Juego.dart</li></b>
    <p>Se presenta esta pantalla iniciando el juego de modo normal o de manera personalizada, ya que ambas redirecciones contienen los mismos parámetros, aquí se almacenan        varias vistas que se mostrarán si has o no has empezado el juego todavia o si lo has terminado</p>
    <b><li>Leaderboard.dart</li></b>
    <p>Lista de los 5 mejores puntajes guardados de manera local, estos son sobreescritos cuando reinicias la aplicación</p>
    <b><li>Config.dart</li></b>
    <p>En esta pantalla (que es un drawer) Encontrarás inputs para que configures el juego a tu gusto, siendo dos de estos inputs también configurables para el juego en modo       contrarreloj</p>
    <b><li>Contrarreloj.dart</li></b>
    <p>Similar a juego pero no se incluye la variable de intentos, ya que este modo de juego funciona según la cantidad de tiempo que se haya escrito en la configuración, al      llegar el contador a 0, se acabará la partida no importa cuánto te equivoques</p>
    <b><li>Providers/counter_providers.dart</li></b>
    <p>Utilizamos providers para cambiar y almacenar nuevos datos que se registran en el juego personalizado, cuando escribas una configuración, la aplicación se asegura de       guardarla por si quieres volver a empezar tu juego personalizado con la misma configuración. A su vez, guarda y almacena todos los registros de puntuación para 
    después ordenarlo de mayor a menor, ningún puntaje se sobreescribirá   
    menor</p>
  </ul>



