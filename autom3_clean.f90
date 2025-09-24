!=======================================================================
!                  /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
!!!!!!!!!!!!!!!!!     MINIMAL CA-BASED MODEL     !!!!!!!!!!!!!!!!!!!!!!!
!                  \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
!
!    Accompanying the paper:
!    "A Minimal CA-Based Model Captures Evolutionarily Relevant Features of Biological Development"
!
!    Authors:
!       Miguel Brun-Usan (1)*, Javier de Juan García (2)*, Roberto Latorre (2)
!       1. CABD – Centro Andaluz de Biología del Desarrollo (CSIC–Universidad Pablo de Olavide), GEM-DMC2 Unit, Campus UPO, 41013 Sevilla, Spain
!       2. Departamento de Ingeniería Informática, Escuela Politécnica Superior, Universidad Autónoma de Madrid, 28049 Madrid, Spain
!       * Authors who coded the program
!       % Correspondence: miguel.brun@csic.es
!
!    License:
!    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or any later version. See <http://www.gnu.org/licenses/>.
!
!    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
!
!    --------------------------------------------------------------------
!    IMPLEMENTATION
!    The whole model is written in Fortran and consists of a single file.
!
!    Compilation (Linux example):
!        sudo apt-get install gfortran
!        gfortran -fbounds-check autom3_clean.f90 -o autom3_clean
!
!    Execution:
!        ./autom3_clean
!
!    Inputs:  none
!    Outputs: A matrix data file (autom.dat) per replicate
!
!    Visualization:
!        Output files can be visualized with standard plotting tools.
!        We also provide a simple Perl script (pdfs6.pl) as an example interface to Gnuplot (GPL license).
!    Dependencies for visualization in Linux (Debian/Ubuntu):
!        Perl: 
!        sudo apt-get install perl
!        Gnuplot: 
!        sudo apt-get install gnuplot
!    Once installed, the provided Perl script (pdfs6.pl) will automatically call Gnuplot to visualize the output files
!    every time the CA reaches a complexity threshold of 500 living cells. This option can be changed or disabled by modifying L164.
!
!    Notes:
!        - THis default setting produces basic morphologies.
!        - No analytical tools for pattern complexity, fractality, or other statistical features are included in this version.
!        - Execution time is generally fast, but depends on the hardware.
!
!=======================================================================




program automaton ! just the main program boosting the system ...

 implicit none
 integer :: i,j,k,n,m,t,tmax,kr,kl,ku,kd,kk,kkk,st,replica,ret,sumatrix,sumatrixmax,sizepi
 real*4  :: x,y,z,freq(1000)
 integer,allocatable :: matrix (:,:,:),matrixt(:,:,:)
 real*4 ,allocatable :: matrixR(:,:),matrixage(:,:)
 integer :: mat(32,32,2),gen(8),env(3)            ! key vector
 integer :: istart, iend, jstart, jend
 sizepi=8
 env(1:3)=(/250,250,100/)                         ! boundary conditions (a,b,c): c<a , c<b
  
 m=env(1) ; n=env(2) ; tmax=env(3)                ! maximum size of the matrix and iterations
    
 allocate(matrix (m,n,2))                         ! live/dead and internal states
 allocate(matrixt(m,n,2))                         ! twin matrix for updating 
 allocate(matrixR(m,n))                           ! M and N must be > prepattern. 
 allocate(matrixage(m,n))                         ! cell's age

 sumatrixmax=0 
 freq=0.0 ; k=0  ; kk=0 ; kkk=0   ! size-frequency
 
do replica=1,6000                                       ! number of replicated (adjust manually as needed)

 ret=SYSTEM('pkill gnuplot')   
 gen=0 

 do i=1,8                                               ! setting the rule vector
   call random_number(x) ;  k=int(x*real(4)+1)
   gen(i)=k   
 end do
 
 do i=1,sizepi                                          ! this creates a random prepattern (initial conditions, maternal)
   do j=1,sizepi                                        ! 
     call random_number(x)
     if(x.ge.0.5)then
       mat(i,j,1)=1
        888 call random_number(y) ; k= 1+int(y*8.0) ; if(k.eq.0)then ; goto 888 ; end if 
       mat(i,j,2)=k                                     ! 1 for just binary/uniform initial states (almost no effect)
     else
       mat(i,j,1:2)=0
     end if
   end do   
 end do  
 ! Cenering EPi Matrix
 istart = m/2 - sizepi/2 + 1 ; iend   = istart + sizepi - 1
 jstart = n/2 - sizepi/2 + 1 ; jend   = jstart + sizepi - 1

 matrix=0
 matrix(istart:iend, jstart:jend, 1:2) = mat(1:sizepi, 1:sizepi, 1:2)
 
 matrixt=0
 matrixage=0
 do t=1,tmax                                               ! Temporal dynamics 
   do i=2,m-1
     do j=2,n-1 
     if(matrix(i,j,1).gt.0)then                            ! only alive cells do things
       k = sum(matrix(i-1:i+1, j-1:j+1, 1)) - matrix(i,j,1)! number of neighbours (Moore), no neighbours nothing happens   
       st=mod(matrix(i,j,2),9)                             ! module, internal states gives direction
       if(k.eq.0)then ; cycle ; end if
       if(gen(k).eq.1)then                                 ! 1st cell behaviour just change state
         matrixt(i,j,1)=matrix(i,j,1) ; matrixt(i,j,2)=matrix(i,j,2)+1
       else if(gen(k).eq.2)then                            ! 2st cell behaviour cell death       
         matrixt(i,j,1:2)=0
       else if(gen(k).eq.3)then                            ! 3rd cell behaviour growth
         matrixt(i,j,1)=1; matrixt(i,j,2)=matrix(i,j,2)
         if(st.eq.1)then ; matrixt(i+1,j,1)=1   ; if(matrix(i+1,j,2).eq.0)then  
           matrixt(i+1,j,2)=matrix(i,j,2)  ; matrixage(i+1,j)=t; end if ; end if 
         if(st.eq.2)then ; matrixt(i+1,j+1,1)=1 ; if(matrix(i+1,j+1,2).eq.0)then
           matrixt(i+1,j+1,2)=matrix(i,j,2); matrixage(i+1,j+1)=t; end if ; end if 
         if(st.eq.3)then ; matrixt(i,j+1,1)=1   ; if(matrix(i,j+1,2).eq.0)then  
           matrixt(i,j+1,2)=matrix(i,j,2)  ; matrixage(i,j+1)=t; end if ; end if 
         if(st.eq.4)then ; matrixt(i-1,j+1,1)=1 ; if(matrix(i-1,j+1,2).eq.0)then
           matrixt(i-1,j+1,2)=matrix(i,j,2); matrixage(i-1,j+1)=t; end if ; end if 
         if(st.eq.5)then ; matrixt(i-1,j,1)=1   ; if(matrix(i-1,j,2).eq.0)then  
           matrixt(i-1,j,2)=matrix(i,j,2)  ; matrixage(i-1,j)=t; end if ; end if 
         if(st.eq.6)then ; matrixt(i-1,j-1,1)=1 ; if(matrix(i-1,j-1,2).eq.0)then 
           matrixt(i-1,j-1,2)=matrix(i,j,2); matrixage(i-1,j-1)=t; end if ; end if 
         if(st.eq.7)then ; matrixt(i,j-1,1)=1   ; if(matrix(i,j-1,2).eq.0)then  
           matrixt(i,j-1,2)=matrix(i,j,2)  ; matrixage(i,j-1)=t; end if ; end if 
         if(st.eq.8)then ; matrixt(i+1,j-1,1)=1 ; if(matrix(i+1,j-1,2).eq.0)then
           matrixt(i+1,j-1,2)=matrix(i,j,2); matrixage(i+1,j-1)=t; end if ; end if              
       else
         matrixt(i,j,1:2)=matrix(i,j,1:2)                   ! nothing happens
       end if
     end if  
     end do
   end do
   
   matrix=matrixt ; matrixt=0                               ! Synchronous update
   sumatrix=sum(matrix(:,:,1))                              ! Nc  
 end do                                                     ! of temporal loop
 
 if(sumatrix.gt.sumatrixmax)then ; sumatrixmax=sumatrix ; end if 
 write(*,*)replica,'sumatrix',sumatrix,sumatrixmax
 k=1+int(real(sumatrix)/10.0)
 if(k.le.1000)then 
   freq(k)=freq(k)+1 ; kk=kk+1
 end if
 
 open(20067,file='autom.dat',status='unknown',action='write') 
 
 do i=2,m-1
   write(20067,*)matrix(i,2:n-1,2)
 end do

 if(sumatrix.gt.500)then          ! plotting interesting patterns
   write(*,*)'replica',replica
   ret=SYSTEM('./pdfs6.pl')    
   write(*,*)
   write(*,*)'EPI matrix'
   do i=1,sizepi
     write(*,*)mat(i,1:sizepi,1)
   end do
   write(*,*)'GENOTYPE'
   write(*,*)gen(1:8)
   read(*,*)
end if
close(20067)

end do                             ! replicates loop

freq=freq/sum(freq)
do i=1,size(freq)
  write(*,*)i,freq(i)              ! basic complexity frequencies (Nc)
end do
 
end program automaton
