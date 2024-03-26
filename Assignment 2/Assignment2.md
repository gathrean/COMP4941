# In-class Assignment 2 (Thread Safety)

## Question 1

- [1 mark] A deadlock is created when threads are waiting for each other to release the lock that they need.  The attached DeadlockSolved.cs does not create a deadlock.  Rearrange the code (do not add any new lines of code or alter an existing one) so that the code creates a deadlock anti-pattern.


### My Answer

- In a threadproc2(), I swapped these two lines “mut2.WaitOne();” and “mut2.WaitOne()”;

Before:

```csharp
private static void threadproc2()
{
  Console.WriteLine("Entering Proc2");
  mut1.WaitOne();
  Thread.Sleep(15000);
  Console.WriteLine("Midpoint in Proc2");
  mut2.WaitOne();
  mut2.ReleaseMutex();
  mut1.ReleaseMutex();
  Console.WriteLine("leaving Proc2");
}
```

After:

```csharp
private static void threadproc2()
{
  Console.WriteLine("Entering Proc2");
  mut2.WaitOne();
  Thread.Sleep(15000);
  Console.WriteLine("Midpoint in Proc2");
  mut1.WaitOne();
  mut2.ReleaseMutex();
  mut1.ReleaseMutex();
  Console.WriteLine("leaving Proc2");
}
```

This way, each mutex is holds one mutex and waits for each other. This way, they end up waiting for each other in a circular fashion. (Stuck)

``` text
Entering Proc2
Entering Proc1
Midpoint in Proc2
```


## Question 2

[2 marks] lock(), Monitor.wait() and Monitor.pulse() are equivalent to synchronized, wait() and notify() methods of java as reflected in the attached ProdCon.cs listing.  However, there is a bug in the listing which upon fixing will produce the same results as the java and C++ producer consumer example of comp3940.  
Also modify the code such that you have two cubbyholes (cells in this case) each having their own producer and consumer thread.

### My Answer

- I’ve made two instances of the Cell class (cell1 and cell2), each with its own producer and consumer threads (prod1, cons1, prod2, and cons2). 

- The synchronization using locks and monitors ensures that the producer-consumer patterns works independently for each cell.

```csharp
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

```

```csharp
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
```