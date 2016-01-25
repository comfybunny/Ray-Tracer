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
}