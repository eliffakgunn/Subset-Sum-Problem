#include <iostream> 
using namespace std; 

int subset[100]; //used for storing elemnets of a current subset
int k=0; //size of current subset
int flag=0; //if subset is found, don't continue any further

/*
in this function, the backtracking technique is used.
backtracking technique generates every sunset only once.
there are two options for eveyr element, either subset includes this element or it does not.
*/
int CheckSumPossibility(int num, int arr[], int arraySize){
	int i, j, sum;

	if(flag == 1)
		return 1;

	for (i = 0; i<arraySize; ++i) { 
		subset[k++] = arr[i]; 

		CheckSumPossibility(num, arr, i); 
		
		sum = 0;

		for(j=0; j<k; ++j)
			sum += subset[j];
		
		if(sum == num){
			if(flag == 0){
				cout<<"Subset: ";
				for(j=0; j<k; ++j)
					cout<<subset[j]<<" ";
				cout<<endl;
			}
			flag = 1;
			return 1;
		}		
		
		--k;		
	} 

	return 0; 
} 

 
int main() { 
	int arraySize;
	int arr[100];
	int num;
	int returnVal; 

	cout<<"Please enter the size of the array:\n";
	cin >> arraySize; 
	cout<<"Please enter the target sum:\n";
	cin >> num; 

	cout<<"Please enter the elements of array.\n";
	for(int i = 0; i < arraySize; ++i) {
		cin >> arr[i]; 
	} 

	returnVal = CheckSumPossibility(num, arr, arraySize); 

	if(returnVal == 1) { 
		cout << "Possible!" << endl; 
	}
	else {
		cout << "Not possible!" << endl; 
	} 

	return 0; 
}