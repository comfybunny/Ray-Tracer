public class DiskLight extends Light{
  
  float radius;
  PVector lightNormal;
  PVector u;
  PVector v;
  
  public DiskLight(Point location, Color lightColor, float radius, PVector lightNormal){
    super(location, lightColor);
    this.radius = radius;
    this.lightNormal = lightNormal;
    PVector w = new PVector();
    if(lightNormal.x == min(lightNormal.x, lightNormal.y, lightNormal.z)){
      w.x = 1;
    }
    else if(lightNormal.y == min(lightNormal.x, lightNormal.y, lightNormal.z)){
      w.y = 1;
    }
    else{
      w.z = 1;
    }
    u = w.cross(lightNormal);
    u = u.div(u.mag());
    v = lightNormal.cross(u);
    v.div(v.mag());
  }
  
  public float getRadius(){
    return radius;
  }
  
  public PVector getLightNormal(){
    return lightNormal;
  }
  
  // this will return a random point on the disk light
  public Point getPoint(){
    float rand_u = (random(2) - 1)*radius;
    float rand_v = (random(2) - 1)*radius;
    PVector totalDisp = new PVector(u.x, u.y, u.z);
    totalDisp.mult(rand_u);
    totalDisp.add(new PVector(v.x, v.y, v.z).mult(rand_v));
    Point lightCenter = getLightCenter();
    Point newPoint = lightCenter.newPoint(totalDisp, 1.0);
    while(newPoint.euclideanDistance(lightCenter) > radius){
      rand_u = random(2) - 1;
      rand_v = random(2) - 1;
      totalDisp = new PVector(u.x, u.y, u.z);
      totalDisp.mult(rand_u);
      totalDisp.add(new PVector(v.x, v.y, v.z).mult(rand_v));
      newPoint = lightCenter.newPoint(totalDisp, 1.0);
    }
    return newPoint;
  }
  
}