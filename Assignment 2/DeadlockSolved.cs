using System;
using System.Threading;
namespace Deadlock
{
    class Program
    {
        private static Mutex mut1 = new Mutex(); 
        private static Mutex mut2 = new Mutex();
        static void Main(string[] args)
        {
            Thread thread1 = new Thread(new ThreadStart(threadproc1));
            Thread thread2 = new Thread(new ThreadStart(threadproc2));
            thread1.Start(); 
            thread2.Start();
        }
        private static void threadproc1()
        {
            Console.WriteLine("Entering Proc1"); 
            mut1.WaitOne();
            Thread.Sleep(15000);
            mut2.WaitOne();
            Console.WriteLine("Midpoint in Proc1");
            mut2.ReleaseMutex(); 
            mut1.ReleaseMutex();
            Console.WriteLine("leaving Proc1");
        }
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
    }
}
