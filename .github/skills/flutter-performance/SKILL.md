---
name: flutter-performance
description: 'Optimize Flutter app performance and improve rendering efficiency. Use when: improving frame rates, reducing jank, optimizing widget rebuilds, caching data, profiling performance, or detecting memory leaks.'
argument-hint: 'Describe the performance issue or optimization goal'
---

# Writing Performant Flutter Code

## When to Use

- Detecting jank or frame drops (< 60 FPS on mobile)
- Optimizing widget rebuilds and re-renders
- Reducing memory usage and heap allocations
- Implementing efficient caching strategies
- Profiling and analyzing app performance
- Implementing lazy loading and pagination
- Optimizing image loading and rendering
- Avoiding common performance pitfalls

## Key Performance Principles

### 1. Widget Rebuild Optimization

**Problem**: Unnecessary rebuilds cause jank and waste CPU cycles.

**Solutions**:
- Use `const` constructors everywhere possible
- Use `final` for fields that don't change
- Split large widgets into smaller, independent widgets
- Use `RepaintBoundary` for expensive widget trees
- Use `const` in lists and collections

**Example**:
```dart
// Bad: Widget rebuilds on every frame
Widget build(BuildContext context) {
  return Column(
    children: [
      Container(color: Colors.blue),  // Rebuilt every time
    ],
  );
}

// Good: Use const
Widget build(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 10),
      const Text("Performance tip"),
    ],
  );
}
```

### 2. State Management Efficiency

**Problem**: Global state changes trigger unnecessary rebuilds across the app.

**Solutions**:
- Use `Provider` with `.select()` to watch specific fields
- Use `ChangeNotifier` instead of `Provider.watch()` when possible
- Keep state as local as possible (lift state no higher than needed)
- Use `GetBuilder`, `Obx`, or `Consumer` to limit rebuild scope

**Pattern**:
```dart
// Bad: Rebuilds entire widget when any state changes
Child(
  model: Provider.of<MyModel>(context),
)

// Good: Only rebuild when count changes
Child(
  count: Provider.of<MyModel>(context).count,
)

// Better: Use select() to watch specific properties
count: context.select<MyModel, int>((m) => m.count)
```

### 3. List and Scroll Performance

**Problem**: Long lists cause jank due to building all widgets at once.

**Solutions**:
- Always use `ListView.builder()` instead of `ListView()` for dynamic content
- Use `ListView.separated()` for lists with dividers
- Set `itemExtent` on ListView if all items have same height
- Use `cacheExtent` to limit off-screen rendering
- Implement `addAutomaticKeepAlives: false` when items are rebuilt

**Example**:
```dart
// Good practice for lists
ListView.builder(
  itemCount: items.length,
  cacheExtent: 500,  // Only buffer ~500px off-screen
  itemBuilder: (context, index) {
    return MealItem(meal: items[index]);
  },
)
```

### 4. Image Optimization

**Problem**: Loading large images blocks the UI and consumes memory.

**Solutions**:
- Use `Image.asset()` with precaching in `initState`
- Use `Image.network()` with caching headers
- Resize images on the backend or use `FittedBox`
- Use `Image.memory()` only for small images
- Precache common images: `precacheImage()`

**Pattern**:
```dart
@override
void initState() {
  super.initState();
  precacheImage(AssetImage('assets/logo.png'), context);
}
```

### 5. Animation Performance

**Problem**: Expensive animations cause frame drops.

**Solutions**:
- Keep animations under 60 FPS (16.7ms per frame)
- Use `SingleTickerProviderStateMixin` instead of `TickerProviderStateMixin` for single animations
- Avoid `Future` inside animation callbacks
- Use `RepaintBoundary` around animating widgets
- Profile with DevTools > Performance to find slow frames

**Example**:
```dart
// Good: Efficient animation
class _AnimatedMealCard extends StatefulWidget {
  @override
  State<_AnimatedMealCard> createState() => _AnimatedMealCardState();
}

class _AnimatedMealCardState extends State<_AnimatedMealCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 6. Data Fetching and Caching

**Problem**: Fetching data on every rebuild or scroll is inefficient.

**Solutions**:
- Cache API responses with TTL
- Use `FutureBuilder` with memoization
- Implement pagination instead of loading all data
- Use `shouldRebuild()` to control rebuild in `Provider`
- Lazy-load data when items become visible

**Pattern**:
```dart
// Good: Cache API data with expiration
final mealProvider = FutureProvider<List<Meal>>((ref) async {
  final cache = ref.watch(mealCacheProvider);
  if (cache != null && !cache.isExpired) {
    return cache.data;
  }
  return fetchMeals();
});
```

### 7. Build Method Performance

**Problem**: Heavy computation in `build()` blocks rendering.

**Solutions**:
- Move expensive operations to `initState()` or isolate
- Use `compute()` for CPU-intensive work
- Avoid `Provider.watch()` in child widgets (watch at parent level)
- Don't call API in `build()`
- Cache calculated values

**Anti-pattern**:
```dart
// BAD: Expensive work on every rebuild
Widget build(BuildContext context) {
  return Text(expensiveCalculation());  // JANK!
}

// GOOD: Calculate once
@override
void initState() {
  _result = expensiveCalculation();
  super.initState();
}
```

## Common Bottlenecks Checklist

- [ ] Using `ListView()` instead of `ListView.builder()`
- [ ] Calling `Provider.of(context)` globally instead of with `.select()`
- [ ] Missing `const` constructors in widget trees
- [ ] Rebuilding large widget trees unnecessarily
- [ ] Loading unresized images
- [ ] Making API calls in `build()` or `didChangeDependencies()`
- [ ] Keeping old `Future` subscriptions alive
- [ ] Not disposing `AnimationController` and `ScrollController`
- [ ] Rendering invisible or off-screen widgets

## Flutter DevTools Performance Tips

1. **Run in Release Mode** to see real performance:
   ```bash
   flutter run --release
   ```

2. **Use Performance overlay** to see FPS:
   ```dart
   showPerformanceOverlay: true,
   ```

3. **Profile with DevTools**:
   ```bash
   flutter pub global activate devtools
   devtools
   ```

4. **Check for jank** in Performance tab (look for red bars > 16.7ms)

## Memory Optimization

- Dispose of resources: `StreamSubscription`, `AnimationController`, `TextEditingController`
- Use `WeakReference` for caches of large objects
- Avoid large static variables
- Profile with DevTools > Memory to find memory leaks
- Use `raster` cache for complex static widgets

## Workflow

1. **Identify**: Use DevTools Performance tab to find slow frames
2. **Profile**: Measure frame time and memory usage
3. **Optimize**: Apply targeted improvements from above
4. **Test**: Re-run in release mode and measure improvements
5. **Monitor**: Add performance metrics to CI/CD pipeline
