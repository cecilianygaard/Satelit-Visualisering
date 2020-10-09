//https://www.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=STDH68-MXH7MF-EC5QEV-4KH4

float angle;
float earthAngle;

JSONObject json;
float r = 150;

PImage earth;
PShape globe;

PFont f;


void setup() {
  size(1000, 1000, P3D);
  f = createFont("Arial", 16, true);
  earth = loadImage("EarthPicture.jpg");

  json = loadJSONObject("https://www.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=STDH68-MXH7MF-EC5QEV-4KH4");
  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
}

void draw() {
  background(51);
  textFont(f, 16);
  textSize(30);
  fill(200);
  text("timestamp = 1602072382", 10, 100);
  displayEarth();
  displaySatelitte();


  if (keyCode == LEFT && keyPressed == true) earthAngle -= 0.1;
  if (keyCode == RIGHT && keyPressed == true) earthAngle += 0.1;
}

void displayEarth() {
  translate(width*0.5, height*0.5);
  lights();
  fill(200);
  noStroke();
  shape(globe);
  rotateY(earthAngle);
}


void displaySatelitte() {
  for (int i = 0; i < json.size(); i++) {
    JSONArray pos = json.getJSONArray("positions");
    JSONObject val = pos.getJSONObject(i);
    float lat = val.getFloat("satlatitude");
    float lon = val.getFloat("satlongitude");
    float alt = val.getFloat("sataltitude");
    float time = val.getFloat("timestamp");

    float theta = radians(lat);
    float phi = radians(lon) + PI;

    float x = (r+alt) * cos(theta) * cos(phi);
    float y = ((-r+alt)) * sin(theta);
    float z = (-(r+alt)) * cos(theta) * sin(phi);


    pushMatrix();
    rotateY(angle);
    angle += 0.003;
    translate(x, y, z);
    fill(255);
    box(10);
    popMatrix();

    println(" alt = " + alt + " lat = " + lat + "  lon = " + lon);
    println("x = " + x + " y = " + y + " z = " + z);
  }
}
