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
}