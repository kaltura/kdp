////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2009 Jacob Wright
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
package jac.image
{
	public final class ResizeStyle
	{
		/**
		 * Makes the entire image visible at the specified width and height
		 * without distortion while maintaining the original aspect ratio.
		 */
		public static const CONSTRAIN_PROPORTIONS:String = "constrainProportions";
		
		/**
		 * Scales the image to fill the specified width and height, without
		 * distortion but centers it and fills any empty space with transparent
		 * pixels, while maintaining the original aspect ratio.
		 */
		public static const CENTER:String = "center";
		
		/**
		 * Scales the image to fill the specified width and height, without
		 * distortion but possibly with some cropping, while maintaining the
		 * original aspect ratio.
		 */
		public static const CROP:String = "crop";
		
		/**
		 * Makes the entire image visible in the specified width and height
		 * without trying to preserve the original aspect ratio. Distortion can
		 * occur.
		 */
		public static const STRETCH:String = "stretch";
		
	}
}