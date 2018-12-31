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
  nice(-15);
  printf("Test start\n");
  for( i=0;i<5;i++){
    pid[i] = fork();
    if(pid[i]==0){
      int counter = 0;
      int counter2 = 0;
      pid_t pid = getpid();
      int begin, end, runningTime;
      nice(5-i);
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
      printf("Number : %d has finished within time %d \n",i,runningTime);
      return 0;
    }
  }

  for(i=0;i<5;i++){
    waitpid(pid[i],NULL,0);
  }
  return 0;
}
