//https://www.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=STDH68-MXH7MF-EC5QEV-4KH4

float angle;
float earthAngle;

JSONObject json;
float r = 130;

PImage earth;
PImage background;
PShape globe;

PFont f;




void setup() {
  size(852, 480, P3D);
  f = createFont("Arial", 16, true);
  earth = loadImage("EarthPicture.jpg");

  json = loadJSONObject("https://www.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=STDH68-MXH7MF-EC5QEV-4KH4");
  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
}

void draw() {
  background(loadImage("SolarSystemBackgroundPicture.jpg"));
  fill(200);
  displayEarth();
  displaySatelitte();


  if (keyCode == LEFT && keyPressed == true) earthAngle -= 0.01;
  if (keyCode == RIGHT && keyPressed == true) earthAngle += 0.01;
  if (keyPressed == false) earthAngle = 0;
}

void displayEarth() {
  translate(width*0.5, height*0.5);
  lights();
  fill(200);
  noStroke();
  shape(globe);
  globe.rotateY(earthAngle);
}


void displaySatelitte() {
  for (int i = 1; i < json.size(); i++) {
    JSONArray pos = json.getJSONArray("positions");
    JSONObject val = pos.getJSONObject(i);
    
    float lat = val.getFloat("satlatitude");
    float lon = val.getFloat("satlongitude");
    float alt = val.getFloat("sataltitude");
    float time = val.getFloat("timestamp");

    textSize(15);
    text("TIMESTAMP: " + time, -400, -205);


    float theta = radians(lat);
    float phi = radians(lon) + PI;

    float x = (r+alt) * cos(theta) * cos(phi);
    float y = r * sin(theta);
    float z = r * cos(theta) * sin(phi);

    PVector posi = new PVector(x, y, z);

    PVector xaxis = new PVector(1, 0, 0);
    float angleb = PVector.angleBetween(xaxis, posi);
    PVector raxis = xaxis.cross(posi);


    pushMatrix();
    rotate(angleb, raxis.x, raxis.y, raxis.z);
    translate(x, y, z);
    fill(255);
    box(10);
    popMatrix();

    println(" alt = " + alt + " lat = " + lat + "  lon = " + lon);
    println("x = " + x + " y = " + y + " z = " + z);
  }
}
