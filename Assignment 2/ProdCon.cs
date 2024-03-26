// MonitorSample.cs
// This example shows use of the following methods of the C# lock keyword
// and the Monitor class 
// in threads:
//      Monitor.Pulse(Object)
//      Monitor.Wait(Object)
using System;
using System.Threading;

public class MonitorSample
{
   public static void Main(String[] args)
   {
      int result = 0;   // Result initialized to say there is no error
      
      Cell cell1 = new Cell();
      Cell cell2 = new Cell();

      CellProd prod1 = new CellProd(cell1, 10, 1);  // Use cell for storage, produce 10 items
      CellCons cons1 = new CellCons(cell1, 10, 1);  // Use cell for storage, consume 10 items
      
      CellProd prod2 = new CellProd(cell2, 5, 2);  // Use cell for storage, produce 10 items
      CellCons cons2 = new CellCons(cell2, 5, 2);  // Use cell for storage, consume 10 items

      Thread producer1 = new Thread(new ThreadStart(prod1.ThreadRun));
      Thread consumer1 = new Thread(new ThreadStart(cons1.ThreadRun));
      
      Thread producer2 = new Thread(new ThreadStart(prod2.ThreadRun));
      Thread consumer2 = new Thread(new ThreadStart(cons2.ThreadRun));
      
      // Threads producer and consumer have been created, 
      // but not started at this point.

      try
      {
         producer1.Start( );
         consumer1.Start( );
         
         producer2.Start( );
         consumer2.Start( );

         producer1.Join( );   // Join both threads with no timeout, Run both until done.
         consumer1.Join( );  
         
         producer2.Join( );   // Join both threads with no timeout, Run both until done.
         consumer2.Join( );  
      // threads producer and consumer have finished at this point.
      }
      catch (ThreadStateException e)
      {
         Console.WriteLine(e);  // Display text of exception
         result = 1;            // Result says there was an error
      }
      catch (ThreadInterruptedException e)
      {
         Console.WriteLine(e);  // This exception means that the thread
                                // was interrupted during a Wait
         result = 1;            // Result says there was an error
      }
      // Even though Main returns void, this provides a return code to 
      // the parent process.
      Environment.ExitCode = result;
   }
}

public class CellProd
{
   Cell cell;         // Field to hold cell object to be used
   int quantity = 1;  // Field for how many items to produce in cell
   int producerId;    // Producer identifier

   public CellProd(Cell box, int request, int id)
   {
      cell = box;          // Pass in what cell object to be used
      quantity = request;  // Pass in how many items to produce in cell
      producerId = id;     // Set the producer identifier
   }

   public void ThreadRun( )
   {
      for(int looper=1; looper<=quantity; looper++)
         cell.WriteToCell(looper, producerId);  // "producing"
   }
}

public class CellCons
{
   Cell cell;         // Field to hold cell object to be used
   int quantity = 1;  // Field for how many items to consume from cell
   int consumerId;    // Consumer identifier

   public CellCons(Cell box, int request, int id)
   {
      cell = box;          // Pass in what cell object to be used
      quantity = request;  // Pass in how many items to consume from cell
      consumerId = id;     // Set the consumer identifier
   }

   public void ThreadRun( )
   {
      int valReturned;
      for(int looper=1; looper<=quantity; looper++)
         // Consume the result by placing it in valReturned.
         valReturned = cell.ReadFromCell(consumerId);
   }
}

public class Cell
{
   int cellContents;         // Cell contents
   bool readerFlag = true;  // State flag
   public int ReadFromCell(int consumerId)
   {
      lock(this)   // Enter synchronization block
      {
         if (!readerFlag)
         {            // Wait until Cell.WriteToCell is done producing
            try
            {
               // Waits for the Monitor.Pulse in WriteToCell
               Monitor.Wait(this);
            }
            catch (SynchronizationLockException e)
            {
               Console.WriteLine(e);
            }
            catch (ThreadInterruptedException e)
            {
               Console.WriteLine(e);
            }
         }
         Console.WriteLine("Consume {0}: {1}", consumerId, cellContents);
         readerFlag = false;        // Reset the state flag to say consuming is done.
         Monitor.Pulse(this);    // Pulse tells Cell.WriteToCell that Cell.ReadFromCell is done.
      }   // Exit synchronization block
      return cellContents;
   }

   public void WriteToCell(int n, int producerId)
   {
      lock(this)  // Enter synchronization block
      {
         if (readerFlag)
         {      // Wait until Cell.ReadFromCell is done consuming.
            try
            {
               Monitor.Wait(this);   // Wait for the Monitor.Pulse in ReadFromCell
            }
            catch (SynchronizationLockException e)
            {
               Console.WriteLine(e);
            }
            catch (ThreadInterruptedException e)
            {
               Console.WriteLine(e);
            }
         }
         cellContents = n;
         Console.WriteLine("Produce {0}: {1}", producerId, cellContents);
         readerFlag = true;    // Reset the state flag to say producing is done
         Monitor.Pulse(this);  // Pulse tells Cell.ReadFromCell that Cell.WriteToCell is done.
      }   // Exit synchronization block
   }
}
