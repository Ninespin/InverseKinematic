/**
* Class representing a mathematical vector.
*/
public class Vector
{
  /**
  * The data of the vector.
  */
  public float[] data;
  
  /**
  * The number of elements of the vector.
  */
  public int sz;
  
  /**
  * Constructor. Initializes the vector to a given size.
  * @param sz  The size.
  */
  public Vector(int sz)
  {
    this.sz = sz;
    this.data = new float[sz];
  }
  
  /**
  * Deep copy constructor.
  */
  public Vector(Vector other)
  {
    this.sz = other.sz;
    this.data = new float[this.sz];
    for(int i = 0; i < this.sz; i++)
    {
      this.data[i] = other.data[i];
    }
  }
  
  /**
  * Deep copy from PVector class constructor.
  */
  public Vector(PVector other)
  {
    this.sz = 3;
    this.data = new float[this.sz];
    this.data[0] = other.x;
    this.data[1] = other.y;
    this.data[2] = other.z;
  }
  
  /**
  * Computes the length of the vector.
  * @return  The length of the vector.
  */
  public float length()
  {
    float len = 0;
    for(int i = 0; i < this.sz; i++)
    {
      len += this.data[i] *this.data[i]; 
    }
    return (float)Math.sqrt(len);
  }
    
  /**
  * Adds the other vector to #this vector.
  * Equivalent to #this = #this + other.
  */
  public void add(Vector other)
  {
    if(this.opCompatible(other))
    {
      for(int i = 0 ; i < sz; i++)
      {
        this.data[i] += other.data[i];
      }
    }
  }
  
  /**
  * Substracts the other vector from #this vector.
  * Equivalent to #this = #this - other.
  */
  public void sub(Vector other)
  {
    if(this.opCompatible(other))
    {
      for(int i = 0 ; i < this.sz; i++)
      {
        this.data[i] -= other.data[i];
      }
    }
  }
  
  /**
  * Computes the dot-product of the other vector onto #this vector.
  * Equivalent to f = #this . other.
  * @param other  The other vector.
  * @return  The dot product.
  */
  public float dot(Vector other)
  {
    float res = 0;
    if(this.opCompatible(other))
    {
      for(int i = 0; i < this.sz; i++)
      {
        res += this.data[i]*other.data[i];
      }
    }
    return res;
  }
  
  /**
  * Gets whether or not the other vector is operations-compatible with
  * #this vector.
  * @param other  The other vector.
  * @return  Whether or not the other vector is operations-compatible with
  */
  public boolean opCompatible(Vector other)
  {
    return this.sz == other.sz;
  }
};
