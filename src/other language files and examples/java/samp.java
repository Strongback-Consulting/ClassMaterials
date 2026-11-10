package java;
import java.util.Arrays;
import java.util.Collections;

public class Main {

    /**
     * a simple method
     */
    public void sortArrayRev() {
        
        Integer[] arrayToSort = new Integer[] {
            new Integer(48), 
            new Integer(5), 
            new Integer(89), 
            new Integer(80), 
            new Integer(81), 
            new Integer(23), 
            new Integer(45), 
            new Integer(16), 
            new Integer(2)
        };
        
        Arrays.sort(arrayToSort, Collections.reverseOrder());
        
        for (Integer i : arrayToSort) {
            System.out.println(i.intValue());
        }
            
    }
    
    /**
     * com. line args
     */
    public static void main(String[] args) {
        Main main = new Main();
        main.sortArrayRev();
        rnd = math.Random();
    }}
