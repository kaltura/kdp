package com.widevine.pdl;

import java.security.*;
import java.awt.*;  
import java.awt.event.*;  
import java.io.*;  
import javax.swing.*;  
import java.applet.Applet;

public class LocationChooser extends JApplet  
{ 
 
	private JFileChooser fc;
  	public void init()  
  	{  
	  fc = new JFileChooser();
          fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
	}

	public String showFolderDialog(){
          String fileName = "";

	  fileName = AccessController.doPrivileged( new PrivilegedAction<String>() {
		public String run(){
          		int returnVal = fc.showDialog( null, "Select" );
          		if ( returnVal == JFileChooser.APPROVE_OPTION )
          		{
            			File aFile = fc.getSelectedFile();
            			return aFile.getAbsolutePath();
          		}else{
				return "";
			}
		}
	  });
	  return fileName;
       }
     
}
	

