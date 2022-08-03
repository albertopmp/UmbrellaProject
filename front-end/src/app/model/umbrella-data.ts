export class UmbrellaData {
  umbrella: boolean;
  rain_prob: number;

  constructor(umbrella: boolean, rain_prob: number) {
    this.umbrella = umbrella;
    this.rain_prob = rain_prob;
  }

  static deserialize(input: any): UmbrellaData {
    return Object.assign(this, input);
  }
}
