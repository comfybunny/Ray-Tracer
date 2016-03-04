// final class so no extensions of class
public static final class StaticUtility{
  // private constructor to prevent installation by client code
  private StaticUtility(){
  }
  
  // static method to solving quadratics; returns -1 when would be imaginary
  public static float quadraticSolver(float a, float b, float c){
    float discriminant = sq(b) - (4*a*c);
        
    if(discriminant < 0){
      return -1;
    }
    float retValPlus = ((-1*b+sqrt(discriminant))/(2.0f*a));
    float retValMinus = ((-1*b-sqrt(discriminant))/(2.0f*a));
    if(retValPlus > retValMinus && retValMinus>0){
      return retValMinus;
    }
    return retValPlus;
  }
  
  // returns -1 if both negative
  public static float smallestPositive(float a, float b){
    if(a > 0 && a < b){
      return a;
    }
    else if(b > 0 && b < a){
      return b;
    }
    return -1;
  }
  
  public static PVector projectTo2D(PVector aPoint, PVector normal){
    float x = abs(normal.x);
    float y = abs(normal.y);
    float z = abs(normal.z);
    
    // x is largest project onto YZ plane
    if(x == max(x,y,z)){
      return new PVector(aPoint.y, aPoint.z, 0);
    }
    // y is largest project onto XZ plane
    else if(y == max(x,y,z)){
      return new PVector(aPoint.x, aPoint.x, 0);
    }
    // else z is largest project onto XY plane
    return new PVector(aPoint.x, aPoint.y, 0);
  }
  
  public static PVector get2Dortho(PVector aPoint){
    return new PVector(aPoint.y*-1.0, aPoint.x);
  }
  
  public static boolean almost_equal(float a, float b){
    if(a < b + 0.000001 && a > b - 0.000001){
      return true;
    }
    return false;
  }
}