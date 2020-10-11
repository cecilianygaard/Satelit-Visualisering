//https://www.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=STDH68-MXH7MF-EC5QEV-4KH4
import java.util.*;
import java.text.*;

float angle;
float earthAngle = 0;

JSONObject json;
float r = 130;

PImage earth;
PImage background;
PShape globe;

PFont f;

float lat = 0;
float lon = 0;
float alt = 0;
long time = 0;

float timeInterval;
float lastTimeCheck;

//Convert radius of satellite relative to the earthRadius (10 times higher over the earth)
float satHeight(float altitude) {
  return(r + altitude * r/6370*10);
  // 6370 is earth radius in km; we multiply with 10 because want the satellite 10 times higher over earth
}


void getSatCoordinates() {
  if (millis() < lastTimeCheck + timeInterval) return;
  json = loadJSONObject("https://www.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=STDH68-MXH7MF-EC5QEV-4KH4");
  JSONArray pos = json.getJSONArray("positions");
  println(pos.size());
  if (pos.size() > 0) {
    JSONObject val = pos.getJSONObject(0);
    lat = val.getFloat("satlatitude");
    lon = val.getFloat("satlongitude");
    alt = val.getFloat("sataltitude");
    time = val.getLong("timestamp");
  }
  lastTimeCheck = millis();
}


void setup() {
  size(852, 480, P3D);
  f = createFont("Arial", 16, true);
  earth = loadImage("EarthPicture.jpg");

  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
  globe.rotateY(PI);

  timeInterval = 5000;
  lastTimeCheck = -timeInterval; //To get position after 5 sec the first time (so the satellite is shown)
}

void draw() {
  background(loadImage("SolarSystemBackgroundPicture.jpg"));
  fill(200);
  displayEarth();
  displaySatelitte();
  getSatCoordinates();

  fill(255);
  textSize(15);
  noLights();
  text("TIMESTAMP: " + epochToDateTime((long)time*1000L), 20, 20);

  if (keyCode == LEFT && keyPressed == true) earthAngle -= 0.05;
  if (keyCode == RIGHT && keyPressed == true) earthAngle += 0.05;
}

void displayEarth() {
  pushMatrix();

  translate(width*0.5, height*0.5);
  rotateY(earthAngle);

  lights();
  fill(200);
  noStroke();
  shape(globe);

  popMatrix();
}


void displaySatelitte() {
  float theta = radians(lon*0.5 + PI);
  float phi = radians(-lat*0.5 + PI);

  float x = satHeight(alt) * cos(theta) * cos(phi);
  float y = satHeight(alt) * cos(theta) * sin(phi);
  float z = satHeight(alt) * sin(theta);


  PVector posi = new PVector(x, y, z);

  PVector xaxis = new PVector(1, 0, 0);
  float angleb = PVector.angleBetween(xaxis, posi);
  PVector raxis = xaxis.cross(posi);

  pushMatrix();

  translate(width*0.5, height*0.5);
  rotateY(earthAngle);
  rotate(angleb, raxis.x, raxis.y, raxis.z);
  translate(x, y, z);

  fill(255);
  box(10);

  popMatrix();

  //  println(" alt = " + alt + " lat = " + lat + "  lon = " + lon);
  //  println("x = " + x + " y = " + y + " z = " + z);
}

String epochToDateTime(long epoch) {
  Date date = new Date(epoch);
  DateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
  format.setTimeZone(TimeZone.getTimeZone("CET"));
  return(format.format(date));
}
