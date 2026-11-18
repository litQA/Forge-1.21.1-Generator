package ${package}.client.gui;

import java.util.Locale;

import net.minecraft.client.gui.components.AbstractSliderButton;
import net.minecraft.network.chat.Component;

/**
 * Slider widget with a numeric range, step size and optional label.
 */
public abstract class ExtendedSlider extends AbstractSliderButton {

	private final Component prefix;
	private final Component suffix;
	private final double minValue;
	private final double maxValue;
	private final double stepSize;
	private final int precision;
	private final boolean drawString;

	public ExtendedSlider(int x, int y, int width, int height, Component prefix, Component suffix, double min, double max,
			double value, double step, int precision, boolean drawString) {
		super(x, y, width, height, prefix.copy(), toSliderValue(value, min, max));
		this.prefix = prefix;
		this.suffix = suffix;
		this.minValue = min;
		this.maxValue = max;
		this.stepSize = step;
		this.precision = Math.max(0, precision);
		this.drawString = drawString;
		this.setValue(value);
	}

	private static double toSliderValue(double value, double min, double max) {
		if (max <= min) {
			return 0.0D;
		}
		return Math.max(0.0D, Math.min(1.0D, (value - min) / (max - min)));
	}

	public double getValue() {
		if (maxValue <= minValue) {
			return minValue;
		}
		return minValue + (maxValue - minValue) * this.value;
	}

	public int getValueInt() {
		return (int) Math.round(this.getValue());
	}

	public void setValue(double value) {
		double clamped = Math.max(minValue, Math.min(maxValue, value));
		if (stepSize > 0.0D) {
			clamped = minValue + Math.round((clamped - minValue) / stepSize) * stepSize;
			clamped = Math.max(minValue, Math.min(maxValue, clamped));
		}
		this.value = toSliderValue(clamped, minValue, maxValue);
		this.updateMessage();
	}

	@Override protected void updateMessage() {
		String format = "%." + this.precision + "f";
		this.setMessage(prefix.copy().append(Component.literal(": " + String.format(Locale.ROOT, format, this.getValue())))
				.append(suffix));
	}

	protected boolean shouldDrawString() {
		return this.drawString;
	}

}
