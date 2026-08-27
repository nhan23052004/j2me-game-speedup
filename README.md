# J2ME Game Speedup Wrapper

A J2ME (Java 2 Micro Edition) wrapper application that allows you to load and run JAR games with adjustable speed multipliers up to **20x faster**.

## Features

- 🎮 **Speed Control**: Adjust game speed from 1x to 20x in real-time
- ⌨️ **Keyboard Shortcuts**: Easy speed adjustment with arrow keys
- 📊 **Speed Visualization**: Visual speed bar shows current multiplier
- 🎯 **Multiple Speed Presets**: 1x, 2x, 5x, 10x, 15x, 20x
- 🔄 **Real-time Adjustment**: Change speed while game is running
- 📱 **MIDP 2.0 Compatible**: Works on most J2ME-enabled devices

## Speed Control Keys

| Key | Action |
|-----|--------|
| **UP Arrow** | Increase speed |
| **DOWN Arrow** | Decrease speed |
| **0** | Reset to 1x speed |
| **\*** | Back to menu |

## Installation & Setup

### Prerequisites

1. **Java Development Kit (JDK)** - Java 1.3 or higher
2. **J2ME Wireless Toolkit (WTK)** - Download from [Oracle WTK](https://www.oracle.com/java/technologies/java-archive-downloads-javame-downloads.html)
3. **Apache Ant** - For building the project

### Configuration

1. Extract the repository:
   ```bash
   git clone https://github.com/nhan23052004/j2me-game-speedup.git
   cd j2me-game-speedup
   ```

2. Edit `build.xml` and update the WTK path:
   ```xml
   <property name="wtk.home" value="C:/WTK2.5.2"/>
   ```
   Change the path to match your WTK installation directory.

3. Configure your CLASSPATH to include Java and Ant.

## Building

### Compile and Build JAR

```bash
ant build
```

This will:
- Compile Java source files
- Preverify bytecode (J2ME requirement)
- Create JAR and JAD files in the `dist/` directory

### Build Output

- `dist/GameSpeedup.jar` - Main application JAR
- `dist/GameSpeedup.jad` - Java Application Descriptor

## Running

### Using Emulator

```bash
ant run
```

This launches the J2ME emulator with the application.

### Manual Emulation

```bash
<WTK_HOME>/bin/emulator -Xdevice:DefaultColorPhone -Xdescriptor:dist/GameSpeedup.jad
```

## How to Use

1. **Launch Application**: Start the MIDlet in your J2ME emulator or device
2. **Select Speed**: Choose desired speed from menu (1x to 20x)
3. **Start Game**: Click "Start" to begin with selected speed
4. **Adjust During Play**:
   - Press UP to increase speed
   - Press DOWN to decrease speed
   - Press 0 to reset to 1x
   - Press * to return to menu

## Architecture

### Main Components

**GameSpeedupMIDlet** (Main MIDlet)
- Manages application lifecycle
- Coordinates display and screen switching

**SpeedControlScreen** (Menu Screen)
- Lists available speed presets
- Allows user to select starting speed

**SpeedupCanvas** (Game Display)
- Renders game at specified speed
- Handles keyboard input for speed adjustment
- Controls frame timing and speed multiplier

### Speed Calculation

The application uses frame-time adjustment:
```
adjusted_frame_time = base_frame_time / speed_multiplier
```

For example:
- Base frame time: 50ms (20 FPS)
- 5x speed: 50ms / 5 = 10ms per frame (100 FPS equivalent)
- 20x speed: 50ms / 20 = 2.5ms per frame (400 FPS equivalent)

## Adding Your Game JAR

To integrate your existing game JAR:

1. Place your game JAR in the `src/` directory
2. Modify `build.xml` to include the JAR as a library
3. Modify `GameSpeedupMIDlet` to load and instantiate your game
4. Rebuild the project

Example modification in build.xml:
```xml
<pathelement location="${src.dir}/YourGame.jar"/>
```

## Troubleshooting

### Build Fails
- Ensure WTK path in `build.xml` is correct
- Check Java version compatibility
- Verify Ant is installed and in PATH

### Emulator Issues
- Update to latest WTK version
- Check device compatibility settings
- Try different device profiles

### Performance
- Reduce speed multiplier if emulator lags
- Check system resources
- Disable other applications

## Project Structure

```
j2me-game-speedup/
├── src/
│   └── GameSpeedupMIDlet.java
├── build/
│   └── classes/
├── dist/
│   ├── GameSpeedup.jar
│   └── GameSpeedup.jad
├── build.xml
└── README.md
```

## Requirements

- **CLDC 1.1** - Connected Limited Device Configuration
- **MIDP 2.0** - Mobile Information Device Profile
- Devices with keyboard support for speed control

## License

Open source - Feel free to modify and redistribute

## Contributing

Improvements and bug fixes are welcome!

## References

- [Oracle J2ME Documentation](https://docs.oracle.com/javame/)
- [MIDP 2.0 Specification](https://jcp.org/en/jsr/detail?id=118)
- [Wireless Toolkit User Guide](https://www.oracle.com/java/technologies/java-archive-downloads-javame-downloads.html)

---

**Created**: 2026  
**Platform**: J2ME (MIDP 2.0 + CLDC 1.1)  
**Status**: Ready for use
