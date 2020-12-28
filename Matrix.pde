/**
* Class representing the mathematical row-major matrix. 
*/
public class Matrix
{
  /**
  * The collection of rows containing the cell values.
  */
  public Vector[] data;
  
  /**
  * The number of rows.
  */
  public int rows;
  
  /**
  * The numbers of columns;
  */
  public int cols;
  
  /**
  * Constructor. Initializes and allocates the matrix using a number
  * of rows and columns. The matrix will be equal to the Zero matrix
  * of corresponding size.
  * @param rows  The number of rows.
  * @param cols  The number of columns.
  */
  public Matrix(int rows, int cols)
  {
    this.rows = rows;
    this.cols = cols;
    this.data = new Vector[rows];
    for(int i = 0; i < this.rows; i++){
      this.setRow(i, new Vector(cols));
    }
  }
  
  /**
  * Deep copy constructor.
  */
  public Matrix(Matrix other)
  {
    this.rows = other.rows;
    this.cols = other.cols;
    this.data = new Vector[this.rows];
    for(int i = 0; i < this.rows; i++){
      this.setRow(i, other.getRow(i));
    }
  }
  
  /**
  * Adds each other cell's value to the corresponding cell in #this matrix.
  * Equivalent to this(j,i) = this(i,j) + other(i,j);
  * @param other  The other matrix.
  */
  public void add(Matrix other)
  {
    if(addCompatible(other))
    {
      for(int i = 0; i < this.rows; i++)
      {
        this.data[i].add(other.data[i]);
      }
    }
  }
  
  /**
  * Substracts each other cell's value to the corresponding cell in #this matrix.
  * Equivalent to this(j,i) = this(i,j) - other(i,j);
  * @param other  The other matrix.
  */
  public void sub(Matrix other)
  {
    if(addCompatible(other))
    {
      for(int i = 0; i < this.rows; i++)
      {
        this.data[i].sub(other.data[i]);
      }
    }
  }
  
  /**
  * Multiplies matrix a with matrix b and returns the resulting matrix.
  * Neither #this, nor a, nor b are modified.
  * Equivalent to C = A * B;
  * @param a  The left matrix.
  * @param b  The right matrix.
  * @return The resulting A * B matrix.
  */
  public Matrix multAB(Matrix a, Matrix b)
  {
    if(a.multCompatible(b))
    {
      Matrix m = new Matrix(a.cols, b.rows);
      for(int i = 0; i < b.rows; i++){
        for(int j = 0; j < a.cols; j++){
          m.setAt(i, j, a.getRow(i).dot(b.getCol(j)));
        }
      }
      return m;
    }
    return null;
  }
  
  /**
  * Multiplies the given vector by the current matrix if possible or does nothing.
  * Neither vector nor #this will be modified.
  * Equivalent to c = A * vector;
  * @param vector  The vector to multiply.
  * @return The resulting vector.
  */
  public Vector multV(Vector vector)
  {

    if(this.cols == vector.sz)
    {
      Vector res = new Vector(this.rows);
      for(int i = 0; i < this.rows; i++){
         res.data[i] = vector.dot(this.getRow(i));
      }
      return res;
    }
    return null;
  }
  
  /**
  * Transposes this matrix.
  */
  public void transpose()
  {
    Matrix temp = new Matrix(this);
    this.rows = temp.cols;
    this.cols = temp.rows;
    this.data = new Vector[this.rows];
    
    for(int i = 0; i < this.rows; i++){
      this.data[i] = new Vector(this.cols);
      for(int j = 0; j < this.cols; j++){
        this.setAt(i,j,temp.getAt(j,i));
      }
    }
  }
  
  /**
  * Gets the row at the given rowIndex if possible or returns null.
  * @param rowIndex  The index of the row to get.
  * @return The desired row or null.
  */
  public Vector getRow(int rowIndex)
  {
    if(this.rows > rowIndex)
    {
      return new Vector(this.data[rowIndex]);
    }
    return null;
  }
  
  /**
  * Gets the column at the given colIndex if possible or returns null.
  * @param colIndex  The index of the column to get.
  * @return The desired column or null.
  */
  public Vector getCol(int colIndex)
  {
    if(this.cols > colIndex)
    {
      Vector result = new Vector(this.rows);
      for(int i = 0; i < this.rows; i++)
      {
        result.data[i] = this.data[i].data[colIndex];
      }
      return result;
    }
    return null;
  }
  
  /**
  * Sets the values of the row at the given rowIndex if possible.
  * @param rowIndex  The index of the row to get.
  * @param values  The new values for the row
  */
  public void setRow( int rowIndex, Vector values)
  {
    if(this.rows > rowIndex && this.cols == values.sz)
    {
      this.data[rowIndex] = new Vector(values); 
    }
  }
  
  /**
  * Sets the values of the column at the given colIndex if possible.
  * @param colIndex  The index of the column to get.
  * @param values  The new values for the column
  */
  public void setCol( int colIndex, Vector values)
  {
    if(this.cols > colIndex && this.rows == values.sz)
    {
      for(int i = 0; i < this.rows; i++)
      {
        this.setAt(i, colIndex, values.data[i]);
      }
    }
  }
  
  /**
  * Gets the value of the cell at row rowIndex and column colIndex if 
  * possible or zero.
  * @param rowIndex  The cell's row index.
  * @param colIndex  The cell's column index.
  * @return  The value of the cell or zero. 
  */
  public float getAt(int rowIndex, int colIndex)
  {
     if(this.rows > rowIndex && this.cols > colIndex)
     {
       return this.data[rowIndex].data[colIndex];
     }
     return 0;
  }
  
  /**
  * Sets the value of the cell at row rowIndex and column colIndex if possible.
  * @param rowIndex  The cell's row index.
  * @param colIndex  The cell's column index.
  * @param value  The new value of the cell.
  */
  public void setAt(int rowIndex, int colIndex, float value)
  {
     if(this.rows > rowIndex && this.cols > colIndex)
     {
       this.data[rowIndex].data[colIndex] = value;
     }
  }
  
  /**
  * Gets whether or not matrix other can be added with #this matrix.
  * @param other  The other matrix.
  * @return Whether or not matrix other can be added with #this matrix.
  * @see #add.
  * @see #sub.
  */
  public boolean addCompatible(Matrix other)
  {
    return this.rows == other.cols && this.cols == other.rows ;
  }
  
  /**
  * Gets whether or not matrix other can be multiplied with #this matrix.
  * @param other  The other matrix.
  * @return Whether or not matrix other can be added with #this matrix.
  * @see #multAB.
  */
  public boolean multCompatible(Matrix other)
  {
    return this.cols == other.rows;
  }
};
