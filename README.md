# Close markup tag for Kakoune

## Feature
| means cursor here
```
<div>
	<p>abc</p>
	|
```
`:close-tag<ret>`
```
<div>
	<p>abc</p>
</div>
```

## To map for insert mode
```
map global insert your-choice '<esc>:close-tag<ret>i'
```
