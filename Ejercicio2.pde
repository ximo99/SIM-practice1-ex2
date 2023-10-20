// Authors:  //<>//
// Julián Rodríguez
// Ximo Casanova

// Problem description:
// El cañón de artillería costera

// Differential equations:


// Definitions:
enum IntegratorType 
{
  NONE,
  EXPLICIT_EULER, 
  SIMPLECTIC_EULER, 
  HEUN, 
  RK2, 
  RK4
}

// Parameters of the numerical integration:
final boolean REAL_TIME = true;
final float SIM_STEP = 0.01;   // Simulation time-step (s)
IntegratorType _integrator = IntegratorType.SIMPLECTIC_EULER;   // ODE integration method

// Display values:
final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)

// Draw values:
final int [] BACKGROUND_COLOR = {200, 200, 255};
final int [] REFERENCE_COLOR = {0, 255, 0};
final int [] OBJECTS_COLOR = {255, 0, 0};
final float OBJECTS_SIZE = 1.0;   // Size of the objects (m)
final float PIXELS_PER_METER = 20.0;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m)

// Parameters of the problem:
final float M = 1.0;   // Particle mass (kg)
final float Gc = 9.801;   // Gravity constant (m/(s*s))
final PVector G = new PVector(0.0, -Gc);   // Acceleration due to gravity (m/(s*s))
final float Kaire = 0.2;
final float Kagua = 2.2;

// Time control:
int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;   // Simulated time (s)
float _elapsedTime = 0.0;   // Elapsed (real) time (s)

// Output control:
//PrintWriter _output;
//final String FILE_NAME = "data.txt";

// Auxiliary variables:
float _energy;   // Total energy of the particle (J)

// altura sobre la que se lanza la masa
int h = 10;

// Angulo del plano y la masa (en grados)
float ang_degree = 30.0;

// Conversión a radianes del angulo en grados
float ang = radians(ang_degree);

// Variables to be solved:
PVector _s = new PVector(0,0);   // Position of the particle (m)
PVector _v = new PVector(cos(ang)*10,sin(ang)*10);   // Velocity of the particle (m/s)
PVector _a = new PVector(0,0);   // Accleration of the particle (m/(s*s))

// Main code:

// Converts distances from world length to pixel length
float worldToPixels(float dist)
{
  return dist*PIXELS_PER_METER;
}

// Converts distances from pixel length to world length
float pixelsToWorld(float dist)
{
  return dist/PIXELS_PER_METER;
}

// Converts a point from world coordinates to screen coordinates
void worldToScreen(PVector worldPos, PVector screenPos)
{
  screenPos.x = 0.5*DISPLAY_SIZE_X + (worldPos.x - DISPLAY_CENTER.x)*PIXELS_PER_METER;
  screenPos.y = 0.5*DISPLAY_SIZE_Y - (worldPos.y - DISPLAY_CENTER.y)*PIXELS_PER_METER;
}

// Converts a point from screen coordinates to world coordinates
void screenToWorld(PVector screenPos, PVector worldPos)
{
  worldPos.x = ((screenPos.x - 0.5*DISPLAY_SIZE_X)/PIXELS_PER_METER) + DISPLAY_CENTER.x;
  worldPos.y = ((0.5*DISPLAY_SIZE_Y - screenPos.y)/PIXELS_PER_METER) + DISPLAY_CENTER.y;
}

void drawStaticEnvironment()
{
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

  textSize(20);
  text("Sim. Step = " + SIM_STEP + " (Real Time = " + REAL_TIME + ")", width*0.025, height*0.075);  
  text("Integrator = " + _integrator, width*0.025, height*0.1);
  text("Energy = " + _energy + " J", width*0.025, height*0.125);
  text("Angle = " + ang + " rad", width*0.025, height*0.150);
  
  
  fill(REFERENCE_COLOR[0], REFERENCE_COLOR[1], REFERENCE_COLOR[2]);
  strokeWeight(1);

  PVector screenPos = new PVector();
  worldToScreen(new PVector(), screenPos);
  
  line(0, screenPos.y, DISPLAY_SIZE_X, screenPos.y);
  
  line(screenPos.x - 200, screenPos.y,0, screenPos.y);

  line(screenPos.x - 200, 0, + screenPos.x - 200, screenPos.y);
  
  fill(0, 0, 255);
      rect(0, screenPos.y, screenPos.x + DISPLAY_SIZE_X, screenPos.y + DISPLAY_SIZE_Y);
  
  fill(255, 0, 0);
  rect(DISPLAY_SIZE_X/2 + 90, screenPos.y - 30, 30, 30);
}

void drawMovingElements()
{
  fill(OBJECTS_COLOR[0], OBJECTS_COLOR[1], OBJECTS_COLOR[2]);
  strokeWeight(1);

  PVector screenPos = new PVector();
  worldToScreen(_s, screenPos);
  
  circle(screenPos.x - 200, screenPos.y - worldToPixels(h), 25);
}

void PrintInfo()
{
  //_output.println(_s.y);
}

void initSimulation()
{
  //_output = createWriter("data.txt");
  _simTime = 0.0;
  _elapsedTime = 0.0;
  
  _s = new PVector(0,0);   // Position of the particle (m)
  _v = new PVector(cos(ang)*10,sin(ang)*10);   // Velocity of the particle (m/s)
  _a = new PVector(0,0);
}

void updateSimulation()
{
  switch (_integrator)
  {
  case EXPLICIT_EULER:
    updateSimulationExplicitEuler();
    break;

  case SIMPLECTIC_EULER:
    updateSimulationSimplecticEuler();
    break;

  case HEUN:
    updateSimulationHeun();
    break;

  case RK2:
    updateSimulationRK2();
    break;

  case RK4:
    updateSimulationRK4();
    break;
  }
  
  _simTime += SIM_STEP;
}

void updateSimulationExplicitEuler()
{
  // Calcular la derivada en el principio del intervalo
  _a = calculateAcceleration(_s, _v);
  
  // Calcular la posición siguiente a partir de la velocidad en el principio del intervalo
  _s.add(PVector.mult(_v, SIM_STEP));
  
  // Calcular la velocidad siguiente a partir de la derivada en el principio del intervalo
  _v.add(PVector.mult(_a, SIM_STEP));
}

void updateSimulationSimplecticEuler()
{
  // Calcular la derivada en el principio del intervalo
  _a = calculateAcceleration(_s, _v);
  
  // Calcular la velocidad siguiente a partir de la derivada en el principio del intervalo  
  _v.add(PVector.mult(_a, SIM_STEP));
  
  // Calcular la posición siguiente a partir de la velocidad en el principio del intervalo  
  _s.add(PVector.mult(_v, SIM_STEP));  
}

void updateSimulationHeun()
{
  // Parte 1, integración numérica de la velocidad
  // Calcular aceleracion a
  _a = calculateAcceleration(_s, _v);
  
  // Paso de Euler, actualizo s2 y v2 (velocidad y posición al final del intervalo)
  PVector _s2 = new PVector();
  _s2 = _s;
  _s2.add(PVector.mult(_v, SIM_STEP));
  PVector _v2 = new PVector();
  _v2 = _v;
  
  // Cálculo de la velocidad promedio a partir de v y v2
  PVector v_prom = PVector.mult(PVector.add(_v, _v2), 0.5);
  
  //actualizar _s con la v promedio
  _s.add(PVector.mult(v_prom, SIM_STEP));
  
  // Parte 2, integración de la acceleración
  // Calcular la aceleración a2 (aceleración al final del intervalo)
  PVector _a2 = new PVector();
  _a2 = calculateAcceleration(_s2, _v2);
  
  // Cálculo de la aceleración promedio a partir de a y a2
  PVector a_prom = PVector.mult(PVector.add(_a, _a2), 0.5);
  
  //Actualizar la velocidad con la aceleración promedio
  _v.add(PVector.mult(a_prom, SIM_STEP));
}

void updateSimulationRK2()
{
  //Calcular acceleracion a
  _a = calculateAcceleration(_s,_v);
  
  // k1s = v(t) * h
  PVector k1s = PVector.mult(_v, SIM_STEP);
  
  // k1v = a(s(t), v(t)) * h
  PVector k1v = PVector.mult(_a, SIM_STEP);
  
  PVector s2 = PVector.add(_s, PVector.mult(k1s, 0.5));
  PVector v2 = PVector.add(_v, PVector.mult(k1v, 0.5));
  PVector a2 = calculateAcceleration(s2,v2);
  
  // k2v = a(s(t) + k1s / 2, v(t) + k1v / 2) * h
  PVector k2v = PVector.mult(a2,SIM_STEP);
  
  // k2s = (v(t)+k1v/2)*h
  PVector k2s = PVector.mult(PVector.add(_v,PVector.mult(k1v,0.5)),SIM_STEP);
  
  _v.add(k2v);
  _s.add(k2s);
}

void updateSimulationRK4()
{
  // Calcular acceleracion a
  _a = calculateAcceleration(_s,_v);

  // k1v = a(s(t), v(t)) * h
  PVector k1v = PVector.mult(_a,SIM_STEP);
  
  // k1s = v(t) * h
  PVector k1s = PVector.mult(_v, SIM_STEP);
  
  // k2v = a(s(t) + k1s / 2, v(t) + k1v / 2) * h  
  PVector s2 = PVector.add(_s, PVector.mult(k1s, 0.5));
  PVector v2 = PVector.add(_v, PVector.mult(k1v, 0.5));
  PVector a2 = calculateAcceleration(s2,v2);
  PVector k2v = PVector.mult(a2,SIM_STEP);
  PVector k2s = PVector.mult(PVector.add(_v,PVector.mult(k1v,0.5)),SIM_STEP);
  
  PVector s3 = PVector.add(_s, PVector.mult(k2s, 0.5));
  PVector v3 = PVector.add(_v, PVector.mult(k2v, 0.5));
  PVector a3 = calculateAcceleration(s3,v3);
  
  // k3v = a(s(t)+k2s/2, v(t)+k2v/2)*h
  PVector k3v = PVector.mult(a3,SIM_STEP);
  
  // k3s = (v(t)+k2v/2)*h
  PVector k3s = PVector.mult(PVector.add(_v,PVector.mult(k2v,0.5)),SIM_STEP);
  
  PVector s4 = PVector.add(_s, k3s);
  PVector v4 = PVector.add(_v, k3v);
  PVector a4 = calculateAcceleration(s4,v4);
  
  // k4v = a(s(t)+k3s, v(t)+k3v)*h
  PVector k4v = PVector.mult(a4,SIM_STEP);
  
  // k4s = (v(t)+k3v)*h
  PVector k4s = PVector.mult(PVector.add(_v,k3s),SIM_STEP);
  
  // v(t+h) = v(t) + (1/6)*k1v + (1/3)*k2v + (1/3)*k3v +(1/6)*k4v
  _v.add(PVector.mult(k1v,1/6.0));
  _v.add(PVector.mult(k2v, 1/3.0));
  _v.add(PVector.mult(k3v, 1/3.0));
  _v.add(PVector.mult(k4v, 1/6.0));
  
  // s(t+h) = s(t) + (1/6)*k1s + (1/3)*k2s + (1/3)*k3s +(1/6)*k4s
  _s.add(PVector.mult(k1s,1/6.0));  
  _s.add(PVector.mult(k2s, 1/3.0));
  _s.add(PVector.mult(k3s, 1/3.0));
  _s.add(PVector.mult(k4s, 1/6.0));
}


PVector calculateAcceleration(PVector s, PVector v)
{
  PVector a = new PVector();
  
  // Sumar fuerzas y dividir f tot entre m
  PVector Froz   = PVector.mult(v,-Kaire);
  PVector Fpeso  = PVector.mult(G, M); 
  PVector Fragua  = PVector.mult(v, -Kagua); 
  
  PVector f = PVector.add(Fpeso, Froz);
  
  if(s.y <= -h)
    f.add(Fragua);
    //stop();
    //f.add(Fragua);
  
  a = PVector.div(f, M);
  return a;
}

void calculateEnergy()
{  
  // ...
  // ...
  // ...
}

void settings()
{
  if (FULL_SCREEN)
  {
    fullScreen();
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();

  initSimulation();
}

void draw()
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  //println("\nDraw step = " + _deltaTimeDraw + " s - " + 1.0/_deltaTimeDraw + " Hz");

  if (REAL_TIME)
  {
    float expectedSimulatedTime = 1.0*_deltaTimeDraw;
    float expectedIterations = expectedSimulatedTime/SIM_STEP;
    int iterations = 0; 

    for (; iterations < floor(expectedIterations); iterations++)
      updateSimulation();

    if ((expectedIterations - iterations) > random(0.0, 1.0))
    {
      updateSimulation();
      iterations++;
    }

    //println("Expected Simulated Time: " + expectedSimulatedTime);
    //println("Expected Iterations: " + expectedIterations);
    //println("Iterations: " + iterations);
  } 
  else
    updateSimulation();

  drawStaticEnvironment();
  drawMovingElements();

  calculateEnergy();
  PrintInfo();
}
void mouseClicked() 
{
  // ...
  // ...
  // ...
}

void keyPressed()
{
  switch(key)
    {
      case 'e':
        _integrator = IntegratorType.EXPLICIT_EULER;
      break;
      
      case 's':
        _integrator = IntegratorType.SIMPLECTIC_EULER;
      break;
      
      case 'h':
        _integrator = IntegratorType.HEUN;
      break;
      
      case '2':
        _integrator = IntegratorType.RK2;
      break;
      
      case '4':
       _integrator = IntegratorType.RK4;
      break;
      
      case 'r':
       initSimulation();
      break;
      
      case 'a':
       ang -= radians(5);
      break;
      
      case 'd':
       ang += radians(5);
      break;
      
      case 'q':
        stop();
      break;
    }
}

void stop()
{
  //_output.flush();
  //_output.close();
  exit();  
}
