<img src="http://office.nousguide.com/nouslogosmall.png" alt="NOUSguide Inc." title="NOUSguide Inc." title" style="display:block; margin: 10px auto 30px auto;" class="center">

# NGVaryingGridView

A GridView which allows to set individual Rects for the Cells. So you can define Cells with different Sizes, used e.g. in Timetables, EPGs, etc.



## Usage

``` objective-c
self.gridView = [[NGVaryingGridView alloc] initWithFrame:self.view.bounds];
self.gridView.gridViewDelegate = self;
[self.view addSubview:self.gridView];
```

The following Delegate-Methods are required:

``` objective-c
// You should return an Array which contains CGRects for every Cell you want to display inside the GridView
- (NSArray *)rectsForCellsInGridView:(NGVaryingGridView *)gridView {
	NSMutableArray *rectsArray = [NSMutableArray array];
	[array addObject:[NSValue valueWithCGRect:CGrectMake(...)]]
	
	// ...
	
	return rectsArray;
}

// return an UIView representing your Cell
- (UIView *)gridView:(NGVaryingGridView *)gridView viewForCellWithRect:(CGRect)rect index:(NSUInteger)index {
	YourUIViewSubclass *gridCell = (YourUIViewSubclass *)[gridView dequeueReusableCell] ? : [[YourUIViewSubclass alloc] initWithFrame:rect];
	gridCell.frame = rect;
	
	// setup gridCell
	
	return gridCell
}
```

## Credits

NGVaryingGridView was created by [Philip Messlehner](https://github.com/messi/)

## License

NGPageControl is available under the MIT license. See the LICENSE file for more info.
For usage without attribution contact [NOUSguide](mailto:info@nousguide.com).