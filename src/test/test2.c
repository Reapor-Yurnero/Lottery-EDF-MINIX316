#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <lib.h>
#include <stdio.h>
#include "time.h"
int main(int argc, char **argv){
  pid_t pid[5];
  int i;
  printf("Test start\n");
  /*chdeadline(2);*/
  nice(-10);
  for( i=0;i<5;i++){
    pid[i] = fork();
    if(pid[i]==0){
      int counter = 0;
      int counter2 = 0;
      pid_t pid = getpid();
      int begin, end, runningTime;
      printf("Child %d:\n", i);
      if (i != 3) chdeadline(20 - 2*i);
      else chdeadline(30);
      begin = time(NULL);
      while(counter2<2){
        counter =0;
        while(counter <1111111111){
          int x =10;
          int y =20;
          x = y*x;
          counter++;
        }
      counter2++;
      }
      end= time(NULL);
      runningTime =  (end-begin);
      printf("Child %d has finished within time %d \n",i,runningTime);
      return 0;
    }
  }

  for(i=0;i<5;i++){
    waitpid(pid[i],NULL,0);
  }
  printf("all child terminated!\n");
  return 0;
}
